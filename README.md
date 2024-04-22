# FilesLabGraphql

Welcome to FileLab-GraphQL! This API provides a robust solution for handling multiple file uploads simultaneously. Built using GraphQL, it allows for the seamless uploading of various file types, from images to documents, while managing the complexity of concurrent operations with Oban-powered background jobs.


## Table of Contents

1. [Demo](#demo)
   - [Prerequisites](#prerequisites)
   - [Execute Upload](#execute-upload)
   - [Explanation](#explanation)
6. [Getting started](#getting-tarted)
2. [Api Documentation](#api-documentation)
3. [Mutations](#mutations)
   - [upload_files](#upload_files)
4. [Subscriptions](#subscriptions)
   - [file_processed](#file_processed)
5. [Additional Information](#additional-information)
   - [Schema Definition](#schema-definition)
   - [Error Handling](#error-handling)
   - [Security Considerations](#security-considerations)

### Demo

Handling multiple file uploads simultaneously from images to documents


#### Prerequisites

- The server should be running on `http://localhost:4000/api`.
- Replace `#{your_file_path}` with the actual path to the files you wish to upload.

#### Execute Upload

````bash
curl -X POST \
  -F query="mutation { uploadFiles(files: [\"file1\", \"file2\"]) }" \
  -F file1=@/#{your_file_path}/file_name.txt \
  -F file2=@/#{your_file_path}/file_name.png \
  http://localhost:4000/api 
````

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
````

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
