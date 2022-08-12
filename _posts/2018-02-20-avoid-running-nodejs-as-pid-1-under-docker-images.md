---
title: Avoid running Node.js as PID 1 under Docker images
excerpt: >-
  We have a lot of applications running inside Docker container as a PID 1. But,
  turns out that it can bring some issues for Node.js applications!
categories:
  - Tips
tags:
  - node.js
  - process
  - pid
  - docker
  - image
header:
  overlay_image: assets/uploads/2018-02-20/docker.jpg
  overlay_filter: 0.5
  caption: Photo by Ian Taylor on Unsplash
  teaser: assets/uploads/2018-02-20/docker.jpg
---

Turns out that Node.js cannot receive signals and handle them appropriately _(if it runs as PID 1)_.
By signals, I mean kernel signals like SIGTERM, SIGINT, etc.

The following code wouldn’t work at all if you run Node.js as PID 1:

```javascript
process.on('SIGTERM', function onSigterm() {
  // do the cleaning job, but it wouldn't
  process.exit(0);
});
```

As a result, you will get a zombie process that will be terminated forcefully via SIGKILL signal, meaning that your “clean up” code will not be called at all.

So what, you might say.
I’ll describe a real case.

## Where does this occur

At my work ([elastic.io](https://elastic.io)), we are using Mesosphere and Kubernetes as our orchestrators.
When Mesos or Kubernetes kills the task, the following is happening:

- Mesos sends SIGTERM and waits for process to die for some time
- If that has not happened, it will send SIGKILL (_which is force kill of the task_) and marks the task as a failed task

The same flow applies to Kubernetes.

If you have Node.js application that listens for RabbitMQ messages, and you will not close all the listeners on SIGTERM, it will continue listening and will not close the process -> SIGKILL arrives to do the job.

Since our platform relies on statuses returned from Mesos/Kubernetes, we make false assumptions about state of the task, bringing to us unknown issues and wrong behavior of the platform.
We never wanted to have unexpected behavior, did we?

## What best practices say about PID 1 case

> Node.js was not designed to run as PID 1 which leads to unexpected behavior when running inside of Docker.
> For example, a Node.js process running as PID 1 will not respond to SIGINT (CTRL-C) and similar signals.
>
> [*reference*](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#handling-kernel-signals)

Boom!

Imagine, you have an app written in Node.js, which is doing some job as a daemon on Mesos/Kubernetes, waiting for the signal to kill it.

You have listeners for SIGTERM, so you can close all the connections daemon uses and notify that everything is ok with exit code 0.

But, it would not.
A Node.js app even cannot understand that someone wants to close it, so it just continues to work, waiting for a SIGKILL signal to come and make a massacre.

## What is the explanation from UNIX perspective

I found a great explanation in [this](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/) article.

> But there is a special case.
> Suppose the parent process terminates, either intentionally (because the program logic has determined that it should exit), or caused by a user action (e.g. the user killed the process).
> What happens then to its children?
> They no longer have a parent process, so they become “orphaned” (this is the actual technical term).
>
> And this is where the init process kicks in.
> The init process — PID 1 — has a special task.
> Its task is to “adopt” orphaned child processes (again, this is the actual technical term).
> This means that the init process becomes the parent of such processes, even though those processes were never created directly by the init process.

And Node.js is not designed to be the init system.
So, that means, any of our applications must be run under some init process, which will spawn our app under itself or will become a parent of such a process.

What is the solution?
How did we fix the problem?
How can we propagate kernel signals to our app?

## Docker init

You can solve the issue by adding flag init when running Docker images:

```shell
docker run --init your_image_here
```

It will wrap your processes with a tiny init system, which will leverage all the kernel signals to its child and make sure that any orphaned processes are reaped.

Well, it’s ok, but what if we need to remap exit codes?
For instance, when Java exits by a SIGTERM signal, it will return exit code 143, not 0.

> When reporting the exit status with the special parameter ‘?’, the shell shall report the full eight bits of exit status available.
> The exit status of a command that terminated because it received a signal shall be reported as greater than 128.
>
> ([*reference*](https://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_08_02))

Docker init cannot handle such cases.
That’s how we found our ideal solution to these cases — Tini.

## Tini

> Tini is the simplest init you could think of.
> All Tini does is spawn a single child (Tini is meant to be run in a container) and wait for it to exit all the while reaping zombies and performing signal forwarding.
>
> ([*reference*](https://github.com/krallin/tini))

With the recent release we could remap exit code 143 to 0, so we can run our Java and Node.js processes under Docker with the following command:

```dockerfile
ENTRYPOINT ["/tini", "-v", "-e", "143", "--", "/runner/init"]
```

## Epilogue

That way, we’ve fixed all the issues related to processing the kernel signals in our applications so they can handle them and respond.

As a bonus, we got the ability to remap exit codes in cases, if a child process responds with (128 + SIGNAL).
I.e., where application got SIGTERM (code 15), sometimes it will be 143 (128 + 15), which means a normal exit from the process.

I hope the article helps you to find some unexpected behavior in your applications.

## References

- [Docker and the PID 1 zombie reaping problem](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)
- [Docker and Node.js Best Practices](https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md)
- [Tini](https://github.com/krallin/tini)

---

*Eugene Obrezkov, Senior Software Engineer at [elastic.io](https://elastic.io), Kyiv, Ukraine.*
