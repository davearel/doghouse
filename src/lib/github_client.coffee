#### github client library which leans on redis
#### Craig Ulliott 2013

redis = require './redis'
request = require 'request'
settings = require './settings'
fs = require 'fs'

organization = settings.get 'github_organization'

github_api_base_uri = 'https://api.github.com'

exports.users = (user, callback) -> 
  get_from_github_with_redis '/orgs/'+organization+'/members?access_token='+user.access_token, callback

exports.repos = (user, callback) -> 
  get_from_github_with_redis '/orgs/'+organization+'/repos?access_token='+user.access_token, callback

exports.organization_issues = (user, callback) -> 
  all_issues = []
  repos_processed_count = 0
  all_repo_names user, (repo_names) ->

    for repo_name, i in repo_names

      # get all the issues in this repo
      # used a closure so we could keep reference to the repo_name, populate the 
      # all_issues hash with the issues from each repo, and fire a callback only once 
      # all asynchronous calls to github and redis have completed
      ( ->
        _repo_name = repo_name
        get_from_github_with_redis '/repos/'+organization+'/'+_repo_name+'/issues?access_token='+user.access_token, (issues) ->

          # only add if its a proper array with length
          if issues.length

            # add repository name to each issue
            for issue in issues
              issue.repository = _repo_name

            # add issues to the collection
            all_issues = all_issues.concat issues

          repos_processed_count++

          # if we have processed all the issues, then trigger the callback 
          callback(all_issues) if repo_names.length == repos_processed_count
      )()

exports.organization_milestones = (user, callback) -> 
  all_milestones = []
  repos_processed_count = 0
  all_repo_names user, (repo_names) ->

    for repo_name, i in repo_names

      # get all the milestones in this repo
      # used a closure so we could keep reference to the repo_name, populate the 
      # all_milestones hash with the milestones from each repo, and fire a callback only once 
      # all asynchronous calls to github and redis have completed
      ( ->
        _repo_name = repo_name
        get_from_github_with_redis '/repos/'+organization+'/'+_repo_name+'/milestones?access_token='+user.access_token, (milestones) ->

          # only add if its a proper array with length
          if milestones.length

            for milestone in milestones
              all_milestones.push { title: milestone['title'] }

          repos_processed_count++

          # if we have processed all the issues, then trigger the callback 
          callback(all_milestones) if repo_names.length == repos_processed_count
      )()

exports.organization_product_labels = (user, callback) -> 
  all_product_labels = []
  repos_processed_count = 0
  all_repo_names user, (repo_names) ->

    for repo_name, i in repo_names

      # get all the labels in this repo
      # used a closure so we could keep reference to the repo_name, populate the 
      # all_product_labels hash with the labels from each repo, and fire a callback only once 
      # all asynchronous calls to github and redis have completed
      ( ->
        _repo_name = repo_name
        get_from_github_with_redis '/repos/'+organization+'/'+_repo_name+'/labels?access_token='+user.access_token, (labels) ->

          # only add if its a proper array with length
          if labels.length

            for label in labels
              label_name = label['name']?.toLowerCase()
              if label_name.substring(0, 2) is "p:"
                all_product_labels.push { name: label_name.replace('p:', '') }

          repos_processed_count++

          # if we have processed all the issues, then trigger the callback 
          callback(all_product_labels) if repo_names.length == repos_processed_count
      )()

all_repo_names = (user, callback) ->
  repo_names = []
  get_from_github_with_redis '/orgs/'+organization+'/repos?access_token='+user.access_token, (repos) ->

    # only add if its a proper array with length
    if repos?.length

      for repo, i in repos

        # ensure only repos with a name get added
        if repo.name then repo_names.push repo.name

    callback repo_names


# get data from github, with a 10 minute cache
get_from_github_with_redis = (path_with_params, callback) ->

  # name space it - because we have shared cache servers  
  cache_key = "doghouse|github|#{path_with_params}"
  
  # first try redis
  redis.get cache_key, (result) ->

    if result?

      # parse the result which is already in redis
      response = []
      try
        response = JSON.parse result

      callback response

    else

      # get it from github and cache the response
      request {

        method: 'GET'
        headers:
          'User-Agent': 'Doghouse'
          'content-type': 'application/json'
        url: github_api_base_uri + path_with_params

      }, (e, r, b) ->

        result = []
        if r.statusCode is 200
          try
            result = JSON.parse b

        # send the result back via the callback
        callback result

        # store the response in redis for next time (up to 10 minutes)
        cache = JSON.stringify result
        redis.set cache_key, cache, 600
