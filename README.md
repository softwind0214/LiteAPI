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
