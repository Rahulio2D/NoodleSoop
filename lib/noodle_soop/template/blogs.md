===
layout: default
===

# Blog Posts

Here are some blogs I've written.

<% foreach blog in blogs %>
    <div class="blog_post">
        <h2>{{ blog.title }}</h2>
        <p>{{ page.content.limit_length(256) }}</p>
    </div>
<% end_foreach %>
