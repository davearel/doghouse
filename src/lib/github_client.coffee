#### github client library which leans on memcached
#### Craig Ulliott 2013

memcache = require './memcache'
request = require 'request'
settings = require './settings'

organization = settings.get("github").organization
github_api_base_uri = 'https://api.github.com'

exports.users = (user, callback) -> 
  get_from_github_with_memcached '/orgs/'+organization+'/members?access_token='+user.access_token, callback

exports.repos = (user, callback) -> 
  get_from_github_with_memcached '/orgs/'+organization+'/repos?access_token='+user.access_token, callback

exports.open_issues = (user, callback) -> 
  all_issues = {}
  repos_processed_count = 0
  all_repo_names user, (repo_names) ->

    for repo_name, i in repo_names

      # get all the issues in this repo
      # used a closure so we could keep reference to the repo_name, populate the 
      # all_issues hash with the issues from each repo, and fire a callback only once 
      # all asynchronous calls to github and memcache have completed
      ( ->
        _repo_name = repo_name
        get_from_github_with_memcached '/repos/'+organization+'/'+_repo_name+'/issues?access_token='+user.access_token, (issues) ->

          # build an array for first time we get a response for this repo
          all_issues[_repo_name] = [] unless all_issues[_repo_name]

          for issue in issues
            all_issues[_repo_name].push(issue) 

          repos_processed_count++

          # if we have processed all the issues, then trigger the callback 
          callback(all_issues) if repo_names.length == repos_processed_count
      )()

all_repo_names = (user, callback) ->
  repo_names = []
  get_from_github_with_memcached '/orgs/'+organization+'/repos?access_token='+user.access_token, (repos) ->
    for repo, i in repos
      repo_names.push(repo['name'])
    callback repo_names


# get data from github, with a 10 minute cache
get_from_github_with_memcached = (path_with_params, callback) ->

  # name space it - because we have shared cache servers
  cache_key = 'doghouse|github|'+path_with_params
  
  # first try memcached
  memcache.get cache_key, (result) ->

    if result
      # parse the result which is already in memcache
      response = JSON.parse(result)
      callback response
  
    else 

      # get it from github and cache the response
      request.get github_api_base_uri + path_with_params, (e, r, b) ->
        # store the response in memcached for next time (up to 10 minutes)
        memcache.set cache_key, r.body, 600, (result) ->

          response = JSON.parse(r.body)
          # send the result back via the callback
          callback response
