# ApiSandbox

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

### Visit [`localhost:4000`](http://localhost:4000) to see the live dashboard.

### GET accounts
```
curl --location --request GET 'http://localhost:4000/api/accounts/' \
--header 'Authorization: Basic dGVzdF9CRGRkV2dfV2FzOg==' \
--header 'Cookie: _api_sandbox_key=SFMyNTY.g3QAAAABbQAAAAtfY3NyZl90b2tlbm0AAAAYVWNROEoyZWlRclBPVHFWd0tPWGJTdWtv.UX16CXV3ce584kxUOzgEIJZbGJnZwvxrpFttV9FcNnc'
```
### GET account
```
curl --location --request GET 'http://localhost:4000/api/accounts/test_acc_Z1dkZERC' \
--header 'Authorization: Basic dGVzdF9CRGRkV2dfV2FzOg=='
```
### GET transactions
```
curl --location --request GET 'http://localhost:4000/api/accounts/test_acc_Z1dkZERC/transactions' \
--header 'Authorization: Basic dGVzdF9CRGRkV2dfV2FzOg=='
```
### GET transaction
```
curl --location --request GET 'http://localhost:4000/api/accounts/test_acc_Z1dkZERC/transactions/test_txn_NTA1' \
--header 'Authorization: Basic dGVzdF9CRGRkV2dfV2FzOg=='
```