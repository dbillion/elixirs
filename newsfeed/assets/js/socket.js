// Import the Socket module from Phoenix
import {Socket} from "phoenix"

// Create a new socket connection
let socket = new Socket("/socket", {params: {token: window.userToken}})

// Connect to the socket
socket.connect()

const createSocket = () => {
  console.log("Creating socket connection to news:latest channel");
  let channel = socket.channel("news:latest", {})
  channel.join()
  .receive("ok", resp => {
      console.log("News feed channel joined successfully", resp);
  }).receive("error", resp => { 
      console.log("Unable to join news channel", resp);
  });

  channel.on("news:latest:new", renderNews);
}

function renderNews(event) {
   console.log("Received news event:", event);
   const renderedNew = contentTemplate(event.news);
   console.log("Rendering news:", renderedNew);
   document.querySelector('.collection').innerHTML += renderedNew;
}

function contentTemplate(news) {
  return "<li class='collection-item'>"+ news + "</li>";
}

// Export it globally for manual calls from the template
// We'll let the template control when to create the socket
window.createSocket = createSocket;