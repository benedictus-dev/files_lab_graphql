# FilesLabGraphql

Welcome to FileLab-GraphQL! This API provides a robust solution for handling multiple file uploads simultaneously. Built using GraphQL, it allows for the seamless uploading of various file types, from images to documents, while managing the complexity of concurrent operations with Oban-powered background jobs.

# GraphQL API Documentation

## Table of Contents

1. [Overview](#overview)
2. [Mutations](#mutations)
   - [upload_files](#upload_files)
3. [Subscriptions](#subscriptions)
   - [file_processed](#file_processed)
4. [Additional Information](#additional-information)
   - [Schema Definition](#schema-definition)
   - [Error Handling](#error-handling)
   - [Security Considerations](#security-considerations)
5. [Getting started](#getting-tarted)

## Overview

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


![Logo](/static/images/logo.png)
