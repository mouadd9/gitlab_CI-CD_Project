# Integration Test Documentation

This document provides a detailed explanation of the integration tests for the `BankAccountController` class. These tests are designed to ensure that the different layers of the application (controller, service, repository, and database) work together correctly.

## Testing Framework and Tools

-   **Spring Boot Test:** The core framework for integration testing in Spring. We use `@SpringBootTest` to load a full application context.
-   **MockMvc:** A powerful tool for testing Spring MVC controllers. It allows us to send HTTP requests to our controllers and assert on the responses without needing to run a real web server.
-   **JUnit 5:** The primary framework for structuring and running the tests.
-   **H2 Database:** An in-memory database used for testing. This ensures that our tests are independent of any external database setup and that the data is clean for each test run.
-   **`@Transactional`:** This annotation is used on the test class to ensure that each test method runs in its own transaction, which is rolled back at the end of the method. This guarantees that tests are isolated from each other and do not leave any data behind.

## Test Class: `BankAccountControllerTest`

This class contains all the integration tests for the `BankAccountController`.

### Setup (`@BeforeEach`)

Before each test, the `setUp()` method is executed. It creates a new `BankAccountDTO`, saves it to the database using the real `bankAccountService`, and stores the created DTO. This ensures that there is at least one bank account in the database for the tests to work with.

### Test Cases

Here is a breakdown of each test method:

#### 1. `getAllAccounts()`

-   **Purpose:** To test the `GET /api/accounts` endpoint.
-   **How it works:**
    1.  It sends a `GET` request to `/api/accounts` using `mockMvc`.
    2.  It asserts that the HTTP response status is `200 OK`.
    3.  It uses `jsonPath` to inspect the JSON response body and asserts that the first account in the returned array has the correct `accountNumber`.

#### 2. `getAccountById()`

-   **Purpose:** To test the `GET /api/accounts/{id}` endpoint for a successful case.
-   **How it works:**
    1.  It sends a `GET` request to `/api/accounts/{id}`, using the ID of the account created in the setup.
    2.  It asserts that the status is `200 OK`.
    3.  It asserts that the `accountNumber` in the JSON response matches the one from the setup.

#### 3. `getAccountById_whenNotFound_shouldReturn404()`

-   **Purpose:** To test that the `GET /api/accounts/{id}` endpoint correctly handles a non-existent ID.
-   **How it works:**
    1.  It sends a `GET` request to `/api/accounts/999` (an ID that is unlikely to exist).
    2.  It asserts that the HTTP response status is `404 Not Found`, verifying that our `GlobalExceptionHandler` is working correctly.

#### 4. `createAccount()`

-   **Purpose:** To test the `POST /api/accounts` endpoint for creating a new account.
-   **How it works:**
    1.  It creates a new `BankAccountDTO` object.
    2.  It converts this object to a JSON string.
    3.  It sends a `POST` request to `/api/accounts` with the JSON payload and `Content-Type` set to `application/json`.
    4.  It asserts that the status is `200 OK`.
    5.  It asserts that the returned JSON object has the correct `accountNumber`.

#### 5. `updateAccount()`

-   **Purpose:** To test the `PUT /api/accounts/{id}` endpoint for updating an account.
-   **How it works:**
    1.  It creates a `BankAccountDTO` with updated details.
    2.  It sends a `PUT` request to `/api/accounts/{id}` with the updated DTO as the JSON payload.
    3.  It asserts that the status is `200 OK`.
    4.  It asserts that the returned JSON object has the updated `accountNumber`.

#### 6. `deleteAccount()`

-   **Purpose:** To test the `DELETE /api/accounts/{id}` endpoint for a successful deletion.
-   **How it works:**
    1.  It sends a `DELETE` request to `/api/accounts/{id}` using the ID of the account created in the setup.
    2.  It asserts that the HTTP response status is `204 No Content`, which is the standard for successful delete operations that don't return a body.

#### 7. `deleteAccount_whenNotFound_shouldReturn404()`

-   **Purpose:** To test that the `DELETE /api/accounts/{id}` endpoint correctly handles a non-existent ID.
-   **How it works:**
    1.  It sends a `DELETE` request to `/api/accounts/999`.
    2.  It asserts that the HTTP response status is `404 Not Found`.

