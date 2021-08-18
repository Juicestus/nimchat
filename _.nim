# (c) Justus Languell 2021

import nigui

var thread: Thread[void]

app.init()
var window = newWindow()
window.width = 800
window.height = 800
app.defaultFontFamily = "Times"

var main = newLayoutContainer(Layout_Vertical)
main.width = 800
main.height = 800
window.add(main)

var sendcont = newLayoutContainer(Layout_Horizontal)

var textcont = newLayoutContainer(Layout_Vertical)
textcont.padding = 25

var usr = newTextBox()
usr.height = 75
usr.width = 500
usr.fontSize = 30
textcont.add(usr)

var msg = newTextBox()
msg.height = 75
msg.width = 500
msg.fontSize = 30
textcont.add(msg)

sendcont.add(textcont)

var button = newButton("Send Message")
button.onClick = proc(event: ClickEvent) =
    echo usr.text
    echo msg.text

button.height = 175
button.widh = 225
button.fontSize = 30
sendcont.add(button)

main.add(sendcont)

proc update() =
    {.gcsafe.}:
        echo msg.text
        app.queueMain(update)

proc start() = 
    {.gcsafe.}:
        app.queueMain(update)

window.show()
createThread(thread, start)
app.run()t
