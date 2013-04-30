settings = require '../lib/settings'

github_client_id = settings.get 'github_client_id'

exports.root_path = () ->
  '/'

exports.github_connect_url = () ->
  'https://github.com/login/oauth/authorize?client_id=' + github_client_id + '&scope=repo'

exports.logout_path = () ->
  '/users/logout'

exports.issues_path = () ->
  '/issues'

# events
# --------------------------------------------
exports.events_path = () ->
  '/events'

exports.new_event_path = () ->
  '/events/new'

exports.create_event_path = () ->
  '/events/create'

exports.edit_event_path = (event) ->
  '/events/' + event.id + '/edit'

exports.update_event_path = (event) ->
  '/events/' + event.id + '/update'

exports.delete_event_path = (event) ->
  '/events/' + event.id + '/delete'

# blog posts
# --------------------------------------------
exports.blog_posts_path = () ->
  '/blog_posts'

exports.new_blog_post_path = () ->
  '/blog_posts/new'

exports.create_blog_post_path = () ->
  '/blog_posts/create'

exports.edit_blog_post_path = (blog_post) ->
  '/blog_posts/' + blog_post.id + '/edit'

exports.update_blog_post_path = (blog_post) ->
  '/blog_posts/' + blog_post.id + '/update'

exports.delete_blog_post_path = (blog_post) ->
  '/blog_posts/' + blog_post.id + '/delete'

