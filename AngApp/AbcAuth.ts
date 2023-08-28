import { MsalModule, MsalInterceptor } from '@azure/msal-angular';
import { IPublicClientApplication, PublicClientApplication, InteractionType } from '@azure/msal-browser';

export function MSALInstanceFactory(): IPublicClientApplication {
  return new PublicClientApplication({
    auth: {
      clientId: 'YOUR_APP_CLIENT_ID',  // Application (Client) ID from Azure portal
      authority: 'https://login.microsoftonline.com/YOUR_TENANT_ID', // Or 'common' for multi-tenant apps
      redirectUri: 'http://localhost:4200/' // or your Angular app's base URL
    },
    cache: {
      cacheLocation: 'localStorage',
      storeAuthStateInCookie: isIE,  // Set to true if you are using IE
    }
  });
}

@NgModule({
  declarations: [
    // Your components here
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MsalModule.forRoot(new PublicClientApplication({
      auth: {
        clientId: 'YOUR_APP_CLIENT_ID', // Application (Client) ID from Azure portal
        redirectUri: 'http://localhost:4200/' // or your Angular app's base URL
      }
    }), {
      interactionType: InteractionType.Popup,
      authRequest: {
        scopes: ['user.read']  // Replace with the scopes you need
      }
    })
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: MsalInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }



----
  import { Component, OnInit } from '@angular/core';
import { MsalService } from '@azure/msal-angular';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {

  constructor(private msalService: MsalService) {}

  ngOnInit() {
    this.msalService.loginPopup().subscribe((response: AuthenticationResult) => {
      this.msalService.instance.setActiveAccount(response.account);
    });
  }
}

====
  npm install @azure/msal-angular
