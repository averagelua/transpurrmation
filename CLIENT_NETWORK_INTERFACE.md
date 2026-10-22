Server -> Client:
loadMap (MapData) -> Load 'MapData' with STI and render
createSelf (CharacterData) -> Create our local character and register movement controls for it
createCharacter (CharacterData) -> Create a non-local character and store in table
roundTimer (number) -> Set the current round time display to this number
updatePosition ({id = CharacterId, position = (x,y)}) -> Set the position of character with id to position
destroyCharacter (id) -> Destroy the character instance for the character of id
roundEnded () -> Clean up all round related game objects
createMessage (username, message) -> Create a message for the username in the chat

Client -> Server:
selectUsername (string) -> Informs the server of your selected username
updatePosition ((x,y)) -> Informs the server to replicate your movement to other clients
sendMessage (string) -> Informs the server to forward your message to other players