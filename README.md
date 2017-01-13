### Introduction

A lite api framework that implemented basic RPC reqirements.
We use chaining coding style to provide convenience of calling methods.
We have covered most situations of http/https request between iOS client and your backend.

#### features

* Store a template, import it and modify very few of params before you call an http request.
* Most of an http request's params can be modified at one method. It's convenient and short.
* Two life cycle callbacks for every request, `willStart` and `didFinish`.
* Make your callbacks dispatching to current/main/background thread by setting a flag.
* Hot-time API environment exchanging.

#### todo

* File transformation support.
* JSON/XML/... to model support.
* More...

### Usage

#### create your API template

```

- (void)createYourAPITemplate {
	[LA createTemplate:^(LARequestMaker *maker) {    
		maker.host(@"http://api.kagou.me").version(@"v1").method(LAMethodGET);
		maker.post(LAPostStyleForm).sync(NO).response(LAResponseStyleJSON);
		maker.willStart.delegate(self, @selector(sign:));
	}
        withIdentifier:@"template"
              onStatus:LAStatusProduction];
}

- (NSURLRequest *)sign:(NSMutableURLRequest *)request {
	//do your sign
	return request;
}

```

#### invoke your API

```

- (void)invokeYourAPI {
	[LA invokeRequest:^(LARequestMaker *maker) {
		maker.import(@"template").path(@"/ping");
		maker.didFinish.block(^id(LAResponse *response){
			NSLog(@"%@", response.JSON);
			return nil;
		});
	}];
}

```

or you may not want to use block:

```

- (void)invokeYourAPI {
	[LA invokeRequest:^(LARequestMaker *maker) {
		maker.import(@"template").path(@"/ping");
		maker.didFinish.delegate(self, @selector(didFinish:));
	}];
}

- (id)didFinish:(LAResponse *)response {
	//do your business
	return nil;
}


```

#### switch your API status

```

- (void)example {
	[LA createTemplate:^(LARequestMaker *maker) {    
		maker.import(@"template").host(@"http://api.test.kagou.me");
	}
        withIdentifier:@"template"
              onStatus:LAStatusBeta];
	[LA switchStatusTo:LAStatusBeta];
}

```
