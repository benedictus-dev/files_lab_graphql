# FilesLabGraphql

Welcome to FileLab-GraphQL! This API provides a robust solution for handling multiple file uploads simultaneously. Built using GraphQL, it allows for the seamless uploading of various file types, from images to documents, while managing the complexity of concurrent operations with Oban-powered background jobs.

## Table of Contents

1. [Demo](#demo)
   - [Prerequisites](#prerequisites)
   - [Execute Upload](#execute-upload)
2. [Features](#features)
   - [Decisions](#decisions) -[Job Processing](#job-processing) -[File Management](#file-management) -[Worker](#worker)
3. [Getting started](#getting-tarted)
4. [Api Documentation](#api-documentation)
5. [Mutations](#mutations)
   - [upload_files](#upload_files)
6. [Subscriptions](#subscriptions)
   - [file_processed](#file_processed)

### Demo

Handling multiple file uploads simultaneously from images to documents

#### Prerequisites

- The server should be running on `http://localhost:4000/api`.
- Replace `#{your_file_path}` with the actual path to the files you wish to upload.

#### Execute Upload

```bash
curl -X POST \
  -F query="mutation { uploadFiles(files: [\"file1\", \"file2\"]) }" \
  -F file1=@/#{your_file_path}/file_name.txt \
  -F file2=@/#{your_file_path}/file_name.png \
  http://localhost:4000/api
```

## Features

### Decisions

# Job Processing

- **Creating Individual Jobs for Each File**
  - **Each file upload creates a separate job, this means if you upload 5 files, 5 independent jobs are enqueued in Oban**
  - **Multiple workers can process multiple files simultaneously**
  - **If one job fails it doesn't affect the processing of other files. Failed jobs can be retried without impacting others**

<img src="/priv/static/images/individual_job_processing.png" alt="individual job example" title="individual job example"/>

- **Creating a Single Job to Handle All Files(Batch Operation)**
  - **Though not implemented, a single job is created regardless of the number of files uploaded. This job is responsible for processing all the files listed in its arguments**
  - **A failure in processing one file can affect the entire job, potentially requiring all files to be reprocessed on retry**

## File Management

- **Uploaded files are deleted from the temporary directory after the request ends, causing Oban to encounter an `{:error, :enoent} ` error when trying to access them.**

  - **Implement a global Agent (FileAgent) for File Handling that starts in our application supervision tree**
    <img src="/priv/static/images/manager1.png" alt="file agent" title="file agent"/>

    <img src="/priv/static/images/manager2.png" alt="file agent" title="file agent"/>

  - **Using `Plug.Upload.give_away/3` we assign ownership of the given upload file to another process(FileAgent)**
    <img src="/priv/static/images/manager3.png" alt="file agent" title="file agent"/>
    <img src="/priv/static/images/manager4.png" alt="file agent" title="file agent"/>
    
  - **Files are retrieved from a temporary directory managed by our File Agent to a more permanent location (priv/static/uploads) where they are available for further use or distribution.**

## Worker

- **Oban worker responsible for processing uploaded files. It fetches file paths and metadata from job arguments, processes each file by copying it to a permanent directory, and cleans up the temporary storage.**
  **Upon successful processing, it publishes an update using GraphQL subscriptions**
  <img src="/priv/static/images/manager5.png" alt="worker example" title="worker"/>

## Features to watch out For

Job Tracking with Unique Identifiers
Error Handling
Security Fix

## Api Documentation

This document provides details about the GraphQL API endpoints, including available mutations and subscriptions, the required input parameters, and the structure of the expected responses.

## Mutations

### `upload_files`

This mutation enables the simultaneous upload of multiple files. Each file is processed asynchronously, allowing for efficient handling of multiple uploads.

#### Input Parameters

- `files`: A non-nullable list of file uploads. Each file in the list is mandatory, ensuring that the API receives the necessary data for processing.

#### Example Mutation Request

```graphql
mutation {
  upload_files(files: [file1, file2]) {
    ...
  }
}
```

### Expected Response

```{
  "data": {
    "upload_files": ["file1_name", "file2_name"]
  }
}
```

### Subscriptions

`file_processed`
Receive updates when a file is processed, with updates broadcasted to all subscribers using a wildcard topic.

```subscription {
  file_processed {
    filename
    content_type
    path
  }
}
```

## Example

```
{
  "data": {
    "file_processed": {
      "filename": "example.jpg",
      "content_type": "image/jpeg",
      "path": "/uploads/example.jpg"
    }
  }
}
```

### Getting Started

To start your Phoenix server:

- **Install dependencies with mix** `deps.get`
- **Create and migrate your database with** `mix ecto.setup`
- **Start Phoenix endpoint with** `mix phx.server`

<img src="/priv/static/images/logo.svg" alt="Alt text" title="Optional title" width="200" height="200"/>
