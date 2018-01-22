# General comments

For the resolution of this exercise I used a light database (SQLite) and the `sequel` Ruby gem. I've added a `Docker` configuration if you don't have the same enviroment in order to execute the tests and the script properly. In order to build the container just run the `docker-compose build` command (only the first time) and then `docker-compose run main bash` to enter the console. Once there you can execute the tests with `rspec spec` and run the script with `ruby scripts/show_me_the_money.rb`

I decided to add a light database for the following reasons:

- The classes are more decoupled.
- It's easier to test.
- The resultant code is more clean.
- The objects grows easily, especially `Bank` because it store the list of accounts and transfer and it could be hard to handle with a high number of account or transfers.

Using the alternative without database the classes would have the following attributes:

**Account:**
- owner: the name of the owner of the account.
- id: unique identificator for the account.

**Transfer:**
- sender: an Account object relative to the sender.
- receiver: an Account object relative to the receiver.
- amount: the amount of the transfer.
- date: the date of the transfer.

**Bank:**
- id: unique identificator for the bank.
- name: name of the bank.
- accounts: an array with Account objects.
- tranfers: an array with Transfer objects.

With this option, each time an account or transfer is created it would be added in the array of the Bank. This is why I think this option would be more coupled.

# Script

The case of the script will return an error because it is not possible due to the tranfer limit. Anyway I rescued this error in order to print all the information that the instructions require.

As the script returns an error it doesn't show the whole behaviour of the solucion but this behaviour could be found documented in the tests.

# Account, Bank, Transfer

These classes are the models with some basic methods required for the solution of the problem.

**Account:**
I've added a method to print the balance because it's required in the script.

**Bank:**
I've added method for retrieving the accounts and the transfers that is required for the modeling part. Also, there is a method for printing the transfer history.

**Transfer:**
In this case I've added methods for access the limit and the commission and a hook for setting the type of the transfer. This way, add new transfers would only imply add a new entry in the `transfer_configs` table and control the new case in this hook.

Another idea for easily adding new transfers would be inherit from this class and create a `TransferFactory` which would be in charge of creating the proper type of transfer.

# TransferAgent
This class is in charge of managing the perform of the transfer. Instead of receive as argument only a `Transfer` object in the constructor I decided to use the id's and the amount. This way, I can control the creation and the stored in the database the transfer when the transfer is complete. This way the user of the script doesn't have to know that the object shouldn't be persisten until the transfer is done.

Regarding the 30% of error, as the instructions doesn't explain how and when these error can be generated, I controlled the any error raised in the transfer process.

# Tests

All the transactions in the tests will be rollbacked, so the tests won't be reflected in the database. I've tried to `mock` all the access to the database but in some cases I had to use the database for some test cases.

# Questions

- **How would you improve your solution?**

**Persistent layer:** I used a very light database in order to have the minimun to solve the problem but it is not optimized. For example, If I knew how all this would be used in an application it is possible to add performance mechanisms such as indexes and some other controls and validations.

**Transfer errors:** in the instructions it is not specified when and why a transfer could fail. With more information about this part I would be able to provide a much better mechanism to manage the fails and assure the consistency of the tranfers.

- **How would you adapt your solution if transfers are not instantaneous?**
I would create an asynchronous system of transfers which allows the transfer agent consult if the transfer is complete, failed or in progress. This way the transfer agent can check periodically the status of the transfer and know when it's done.
