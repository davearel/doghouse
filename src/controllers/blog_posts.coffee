BlogPost = require '../models/blog_post'
User = require '../models/user'

exports.index = (req, res) ->
  BlogPost.find {}, (err, blog_posts) ->
    res.render 'blog_posts/index',  blog_posts: blog_posts

exports.new = (req, res) ->
  res.render 'blog_posts/form'

exports.create = (req, res) ->
  res.locals.withCurrentUser (user) ->
    # signed in
    blog_post = new BlogPost req.body
    blog_post.created_by = user._id
    blog_post.save (err, blog_post) ->
      if not err
        res.redirect '/blog_posts'
        return
      else
        res.statusCode = 500
        res.render 'blog_posts/form', blog_post: blog_post
        return
    # not signed in
  , () ->
    res.statusCode = 403
    res.redirect '/'

exports.edit = (req, res) ->
  BlogPost.findById req.params.id, (err, blog_post) ->
    res.render 'blog_posts/form', blog_post: blog_post

exports.update = (req, res) ->
  BlogPost.findByIdAndUpdate req.params.id, {"$set":req.body}, (err, blog_post) ->
    if not err
      res.redirect '/blog_posts'
    else
      res.statusCode = 500
      res.render 'blog_posts/form', blog_post: blog_post

exports.delete = (req, res) ->
  BlogPost.findByIdAndRemove req.params.id, (err) ->
    res.redirect '/blog_posts'
