import { Injectable } from '@angular/core';
import { MsalService } from '@azure/msal-angular';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private msalService: MsalService) {}

  // Log in and get a token
  async loginAndGetToken(): Promise<string> {
    const result = await this.msalService.loginPopup({ scopes: ['user.read'] }).toPromise();

    if (result && result.accessToken) {
      return result.accessToken;
    }

    throw new Error('Failed to authenticate.');
  }
}

====

import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { MsalModule } from '@azure/msal-angular';
import { AppComponent } from './app.component';
import { AuthService } from './auth.service';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    MsalModule.forRoot({
      auth: {
        clientId: 'YOUR_APP_CLIENT_ID',  // Application (Client) ID from Azure portal
        authority: 'https://login.microsoftonline.com/YOUR_TENANT_ID',
        redirectUri: window.location.origin,
      },
      cache: {
        cacheLocation: 'localStorage',
      },
    })
  ],
  providers: [AuthService],
  bootstrap: [AppComponent]
})
export class AppModule { }
======


  import { Component, OnInit } from '@angular/core';
import { AuthService } from './auth.service';

@Component({
  selector: 'app-root',
  template: `<button (click)="login()">Login and Get Token</button>`,
})
export class AppComponent implements OnInit {

  constructor(private authService: AuthService) {}

  async login() {
    try {
      const token = await this.authService.loginAndGetToken();
      console.log('Token:', token);
    } catch (error) {
      console.error('Authentication failed:', error);
    }
  }
}
  
