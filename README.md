# Medium Blog

## Requirements
- Ruby 2.6.9
- MySQL 5.7 or 8
- Node 16.17.1

## Installation

Clone the repo locally:
```
https://github.com/scm-ojt/medium-blog-advanced-myattheingiaung.git
```

`cd` into cloned directory

`cd server`
```
bundle install
```

`cd client`
```
npm install
```

## Database Migration

`cd server`

Run database creations:
```
rails db:create
```

Run database migrations:
```
rails db:migrate
```

Run database seeder:
```
rails db:seed
```

## Server Run
`cd server`

Run the dev server:
```
rails server
```

`cd client`

```
npm run serve
```

Visit below url:
```
http://127.0.0.1:8080/
```
