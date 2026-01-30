// Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

var examplecorp = window.examplecorp || {};

(function scopeWrapper($) {
    
    var poolData = {
        UserPoolId: _config.cognito.userPoolId,
        ClientId: _config.cognito.userPoolClientId
    };

    var userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

    if (typeof AWSCognito !== 'undefined') {
        AWSCognito.config.region = _config.cognito.region;
    }

    examplecorp.authToken = new Promise(function fetchCurrentAuthToken(resolve, reject) {
        var cognitoUser = userPool.getCurrentUser();

        if (cognitoUser) {
            cognitoUser.getSession(function sessionCallback(err, session) {
                if (err) {
                    reject(err);
                } else if (!session.isValid()) {
                    resolve(null);
                } else {
                    resolve(session.getIdToken().getJwtToken());
                }
            });
        } else {
            resolve(null);
        }
    });

    function signin(email, password, onSuccess, onFailure) {
        var authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails({
            Username: email,
            Password: password
        });

        var cognitoUser = createCognitoUser(email);
        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: onSuccess,
            onFailure: onFailure
        });
    }

    function createCognitoUser(email) {
        return new AmazonCognitoIdentity.CognitoUser({
            Username: email,
            Pool: userPool
        });
    }

    $(function onDocReady() {
        $('#signinForm').submit(handleSignin);
    });
    function examplecorpURLGenCall(authToken){
        $.ajax({
            method: 'POST',
            url: _config.api.invokeUrl + '/auth',
            headers: {
                Authorization: authToken
            },
            contentType: 'application/json',
            success: function(response, status){
                console.log('Status: ' + status + '.' + ' API Gatway call was successful, redirecting to examplecorp Streaming URL.')
                window.location.href = response.Message;
            },
            error: function(response, status){
                console.log('Status: ' + status + '.');
                console.log(response);
                alert('Amazon API Gateway can’t process the request right now because of an internal error. Try again later.');
                window.location.href = 'index.html';
            }
        }); 
    }
    function handleSignin(event) {
        var email = $('#emailInputSignin').val();
        var password = $('#passwordInputSignin').val();
        event.preventDefault();
        signin(email, password,
            function signinSuccess() {
                var authToken;
                examplecorp.authToken.then(function setAuthToken(token) {
                    if (token) {
                        console.log('Auth token set.');
                        authToken = token;
                        examplecorpURLGenCall(authToken);
                    } else if(!token) {
                        var cognitoUser = userPool.getCurrentUser();
                        if (cognitoUser != null) {
                            cognitoUser.getSession(function(err, session) {
                                if (err) {
                                    console.log(err);
                                    return;
                                }
                                else {
                                authToken = session.getIdToken().getJwtToken();
                                console.log("Refresh.")
                                }
                                examplecorpURLGenCall(authToken);
                            });
                        
                        }
                    } else {
                        alert("Amazon Cognito can’t process the sign-in request right now because of an internal error. Try again later.");
                        window.location.href = 'index.html';
                    }
                }).catch(function handleTokenError(error) {
                    window.location.href = 'index.html';
                    console.log('Error: ' + error)
                });
            },
            function signinError(err) {
                alert("Amazon Cognito can’t process the sign-in request right now because of an internal error. Try again later.");
                console.log(err)
            }
        );
    }
}(jQuery));