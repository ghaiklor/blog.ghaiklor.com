---
title: How I migrated from Medium to WordPress.com and why?
excerpt: >-
  For the last year, strange things were happening with Medium. Many people
  complained that Medium hides everything behind the paywall, but I didn't get
  it, until recently... but let us start from beginning.
categories:
  - How-To
tags:
  - medium
  - wordpress
  - migration
  - blogging
  - platform
header:
  overlay_image: assets/uploads/2019-06-07/migration.jpg
  overlay_filter: 0.5
  caption: Photo by Sébastien Goldberg on Unsplash
  teaser: assets/uploads/2019-06-07/migration.jpg
---

My first blog was a static page on GitHub, written in Markdown.
They were deploying through Jekyll.
I love everything about Jekyll and GitHub Pages, but when you need to make drafts, share them with your technical editor, got comments on your writing style, etc... it becomes harder to handle all of that, since these are just plain Markdown files.

While looking for other solutions, I'd found Medium a few years ago.
It was a breakthrough.
It has a WYSIWYG editor, you can make drafts and share them with people, getting the feedback as comments to your lines.
You were fixing those issues and "Publish".
Decent!

Everything was great until they had introduced paid membership.
They were selling this with a motto "let your posts make you money" or something like that.
It was optional, so I just refused and forgot about it.
You still can read other's people posts, write your own, so what is the difference, right?

For some time, yes, but… few days ago I log in into Medium to read some interesting posts about Computer Science and you know what I saw there?
They hid almost every post on Medium behind the paywall.
I'll show you how it looks:

{% include figure image_path="assets/uploads/2019-06-07/medium-paywall.png" alt="Medium Paywall" caption="Medium Paywall" %}

What is that, Medium?
Are you kidding me?

And you will see this banner a lot, believe me.
More and more posts on Medium are hiding behind the paywall.
I had open like ~8 articles at that day and I could read only one; they hid others behind the banner you see above.

So I decided, I'm moving.

And I'm writing this post alongside the process of migration.
Everything I'm doing right now for migration, I'm writing in this draft.
So, read it with the idea in mind that you are sitting next to me in the office and looking how I'm doing that.
Let us begin.

## Export from Medium

What do we need to do in the first place?
Right, export everything we had on Medium.

To do that, we are going to Medium.
Go to "Profile -> Settings -> Account".
Look for "Download your information" section and, well, download it:

{% include figure image_path="assets/uploads/2019-06-07/medium-download-info.png" alt="Medium Download Information" caption="Medium Download Information" %}

You will get an email with a link for downloading a zip archive with all your content.
Now, when we got the archive, we need to import it somehow into WordPress.com.

## Import to WordPress.com

WordPress.com has a tool for importing content from Medium.
Go to your website on WordPress.com "My Site -> Tools -> Import".

{% include figure image_path="assets/uploads/2019-06-07/wordpress-import-content.png" alt="Wordpress Import Content" caption="Wordpress.com Import Content" %}

As you can see, it has a lot of importers, so you can migrate from others' resources.
However, we are interested in Medium.

It asks for a zip file; you have downloaded early, so we give it and wait for some results.

{% include figure image_path="assets/uploads/2019-06-07/wordpress-import-zip.png" alt="Wordpress Import ZIP" caption="Wordpress.com Import ZIP" %}

I've waited for ten minutes, something like that.
When WordPress.com has done with the import, I got an email notification about that and navigated to my posts on WordPress.com:

{% include figure image_path="assets/uploads/2019-06-07/wordpress-imported-posts.png" alt="Wordpress Imported Posts" caption="Wordpress.com Imported Posts" %}

WordPress.com has migrated all of my posts from Medium - decent!

## Proofreading

I wanted to double-check that import has not broken something.
I mean, styling, embedded code or gists from GitHub, images, etc…

So I went through each of the imported posts and did a proofreading, nothing special here.
If you by chance will find errors in my old posts, please notify me about that and I'll fix it, thanks.

BTW, regard to proofreading, I am using the tool called [ProWritingAid](https://prowritingaid.com/).
It has checks for styling, grammar, [Flesch–Kincaid readability tests](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests) and a lot more.
I'd even say it worth describing the tool more in depth in another post.

Alternatives to help you with writing posts are [Hemingway App](http://www.hemingwayapp.com/) or [Grammarly](https://grammarly.com/).

Though we are already getting off the tracks, let us return to the migration.
We have posts on WordPress.com.
In my case, they are available at [ghaiklor.wordpress.com](http://ghaiklor.wordpress.com).
And let us say we can just take our custom domain [blog.ghaiklor.com](http://blog.ghaiklor.com) and switch it to the WordPress.com.
Not so fast...

## Backward Compatibility

What about old links somewhere in notes, bookmarks?
For example, the same article and links to both Medium and WordPress.com:

- Medium: `https://blog.ghaiklor.com/how-nodejs-works-bfe09efc80ca`
- WordPress.com: `https://blog.ghaiklor.com/2015/08/23/how-does-nodejs-work`

As you can see, they have different permalinks, so switching the domain right away will break all the links in Medium style.
That means we need to support old permalinks in WordPress.com.
We need to find a way route Medium links to WordPress.com posts.
**Redirects come to the rescue**.

But first, you need to get all the links to your Medium posts.
I have scrapped them into my Notes:

{% include figure image_path="assets/uploads/2019-06-07/notes-permalinks-list.png" alt="Permalinks List" caption="Permalinks List" %}

Ready to create redirects turns out that WordPress.com does not have a built-in functionality for that (_I am shocked_).
They have plugins, but you can install them only if you have a business plan bought.
Well, I do not.

Let us find some way around that…

After a few hours of brainstorming, I'd found a way to overcome this limitation.
You can create custom pages on WordPress.com and as their slugs you need to provide the old links from Medium.

Here, for example, I want to notify users that will go by the old link to "How does Node.js work?", that it is no more correct and that you need to follow another link.

{% include figure image_path="assets/uploads/2019-06-07/wordpress-medium-slug.png" alt="Medium-like Permalink" caption="Medium-like Permalink" %}

Inspect the URL of the page.
Remember, we were talking about Medium links like `https://blog.ghaiklor.com/how-nodejs-works-bfe09efc80ca`.
Now, these links are just custom pages on WordPress.com, where you can notify your readers about the migration and give them a valid link to the post.

It is not 301 or 302 redirects, so I'm afraid it will confuse search engines about what is happening there.
But what choices do we have here?
At least, we can notify readers where to go, instead of “the page is not found”.

## Switch the domain

Now, when all the preparations were done, we could go to our domain registrar and update records, in my case blog.ghaiklor.com, to point to WordPress.com name servers instead of Medium ones and finish the migration.

I will skip the story of updating DNS records, because, this is custom thing and differs from one registrar to another.
All you need to know is that at this step, you just need to update your DNS record and you can find all the documentation about that at your domain registrar and WordPress.com documentation.

## Results

Let us summarize:

- We had exported all our content from Medium
- Imported it into WordPress.com
- Made a proof-reading to ensure that everything looks perfect
- It is "backward compatible" with old Medium links
- Switched the custom domain to point to the WordPress.com name servers

We have migrated the blog, congratulations!

---

*Eugene Obrezkov, Senior Software Engineer, Kyiv, Ukraine.*
