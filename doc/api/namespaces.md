## List namespaces

Get a list of possible namespaces for the authenticated user.

```
GET /namespaces
```

```json
[
  {
    "id": 1,
    "name": "root",
    "path": "root"
  },
  {
    "id": 99,
    "name": "GitLab",
    "path": "gitlab"
  },
  {
    "id": 400,
    "name": "admin",
    "path": "admin"
  },
]
```

Return values:

+ `200 Ok` on success and a list of namespaces
+ `401 Unauthorized` if user is not authenticated
+ `404 Not Found` if something else fails


## Get single namespace

Gets a single namespace, identified by namespace ID, which must be accessible by the authenticated user.

```
GET /namespaces/:id
```

Parameters:

+ `id` (required) - the ID of the namespace

Return values:

+ `200 Ok` on success and the single namespace
+ `401 Unauthorized` if user is not authenticated
+ `404 Not Found` if the namespace ID could not be found
