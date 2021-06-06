This is an implementation for the task required by Smart Pension as a first stage in the interview.

### Installation
```
$ bundle install
```

### Usage
```shell
$ ./parser.rb webserver.log

```

The default behaviour is to fail for a malformed log line.

A properly formatted log line is as follows: "/some/url ip"

By default IP is not validated. It is treated as a unique string identifier.

To skip a malformed line and progress to a following line

```shell
$ ./parser.rb webserver.log --skip
```

To validate IP

```shell
$ ./parser.rb webserver.log --validate-ip
```

Note: If the IP is invalid, it will be treated as a malformatted line. Then whether skip a line or not depends on the other argument.

The app is built to be extended to use multiple parsers. We can run the app and specifying the name of the another parser so the parsing logic is different. All what we need to do is to implement a new parser in `lib/parsers.rb` then pass the name of the parser to the app as follows:

```shell
$ ./parser.rb webserver.log --parser PARSER_NAME
```

PARSER_NAME by default carries the value of `url_and_ip`. which is the name of the parser required.

You can also specify the log level in the options. It defaults to `warn`

```shell
$ ./parser.rb not_a_file --log-level debug

```

The project uses rspec for testing. To run the tests, simply type

```shell
$ rspec
```

You can check the coverage report in `coverage/index.html`

You can also validate coding tyles via rubocop by typing:

```shell
$ rubocop
```