# A full stack ToDo Application with OCR: EASY TODO

## Tools used:
1. I made the backend of this app in node.js.
2. Express was used for routing.
3. While making the folder structure, I took care of the SOC.
4. User and task routing was done separately.
5. User and task controllers were handled properly.
6. I used jwt for authentication and authorization.
7. I have used Redis to handle the blacklisting of tokens.
8. Logger and error-handling middleware were added to keep track of all the changes and errors.
9. Mongoose was used for storing the todos.
10. Data access layer was handled separately in services folder.
11. There is an endpoint that handles multipart request. This is used to create todos using a picture.

## Flutter app
Flutter was used to create the frontend of the app. Using this app you can create your own todos just like any other app and if you have written todos on a paper or anywhere else, you can take their picture and then upload it to the app to make todos from them.
### Registration and Login:
The login and registration functionality communicates with the nodejs backend to create a user or sign in with the user. The validation part is handled in the backend and access and refresh tokens are saved in Shared preferences in app.
![image](https://github.com/user-attachments/assets/1a5d657d-de41-4660-b808-f528a2621e9e)
![image](https://github.com/user-attachments/assets/23337cf6-d653-4c84-bd38-9675eed9890f)

### Home Screen:
Home screen is designed to show all the todos on the main screen. Completed and pending todos are shown with options to update or delete them. This also communicates with backend to do this task. 
There is also a logout button on the top to sign the user out. When you sign out, the backend ensures that your token is blacklisted and you cannot access the routes again.
![image](https://github.com/user-attachments/assets/8418ae90-a9a6-4701-8042-c745455c356e)


### Add todo using picture:
You can select a picture from the gallery of a todo to get its todos created in the app.
![image](https://github.com/user-attachments/assets/b037222b-a211-47e6-98f4-849bb1e79bc6)
![image](https://github.com/user-attachments/assets/daf466d9-3a0a-4134-8a73-794939928986)

### Create todo using fields
![image](https://github.com/user-attachments/assets/7fe86a5a-9f9d-4957-bd4a-724707748084)

### Edit Todo:
You can edit the todos easily using calendar and clock for the date and time respectively
![image](https://github.com/user-attachments/assets/897234fe-3df6-4d07-bb81-d48524c47f83)
![image](https://github.com/user-attachments/assets/bcd259fe-bf32-4ed6-8d50-c50b1787d496)

### View todos by status:
You can click on completed or pending todos tiles to see only the todos of the respective status.
![image](https://github.com/user-attachments/assets/ca9eab71-c743-49b5-b370-cb0ebd2a14d1)









