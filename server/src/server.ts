import cors from "cors";
import dotenv from "dotenv";
import express from "express";
import http from "http";
import { WebSocket, WebSocketServer } from "ws";

dotenv.config();  //configure dotnet file
const app = express(); //create express app
const server = http.createServer(app); //create http server
const webSocketServer = new WebSocketServer({ server }); //convert http server to web socket server

//configure cross origin and express json
app.use(cors());
app.use(express.json());

//crate web socket connection
webSocketServer.on("connection", (webSocket:WebSocket) => {
    console.log("New Client Connected Succsussfuly");
    
    //send massages to other  clients
    webSocket.on("message", (data) => {
        console.log("Received a message from the client: " + data);
        webSocketServer.clients.forEach((client) => {
            if (client !== webSocket && client.readyState === webSocket.OPEN) {
                client.send(data);
                }
        });
    });
   // terminate connection
    webSocket.on("close", () => {
        console.log("Connection closed");
    });

});
//run on server
const PORT = process.env.PORT;
server.listen(PORT, () => {
    console.log(`Sever is running on port ${PORT}`); 
});