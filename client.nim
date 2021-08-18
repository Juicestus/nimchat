# (c) Justus Languell 2021

import nigui
import httpclient
import json

var thread: Thread[void]

var reciv: int = 0

var client = newHttpClient()

var address: string = "http://127.0.0.1:5000"

app.init()
var window = newWindow("")
window.width = 800
window.height = 1000
app.defaultFontFamily = "Times"

var main = newLayoutContainer(Layout_Vertical)
main.width = 800
main.height = 1000
window.add(main)

var title = newLabel("Nim Example Chat")
title.fontSize = 50
title.widthMode = WidthMode_Expand
title.height = 75
title.fontBold = true
title.xTextAlign = XTextAlign_Center
main.add(title)

var subtitle = newLabel("Client/server chat application built in pure Nim for practice, (c) Justus Languell 2021")
subtitle.fontSize = 20
subtitle.widthMode = WidthMode_Fill
subtitle.height = 50
subtitle.fontBold = false
subtitle.xTextAlign = XTextAlign_Center
main.add(subtitle)

var mbox = newLayoutContainer(Layout_Vertical)
mbox.width = 600
mbox.height = 420
mbox.padding = 15
mbox.heightMode = HeightMode_Expand
mbox.scrollableHeight = 600
main.add(mbox)

var sendcont = newLayoutContainer(Layout_Horizontal)

var textcont = newLayoutContainer(Layout_Vertical)
textcont.padding = 10

var usrcont = newLayoutContainer(Layout_Horizontal)
usrcont.padding = 5

var usrl = newLabel("Username")
usrl.width = 100
usrl.height = 50
usrl.fontSize = 24
usrcont.add(usrl)

var usr = newTextBox()
usr.height = 50
usr.width = 380
usr.fontSize = 30

usrcont.add(usr)
textcont.add(usrcont)

var msgcont = newLayoutContainer(Layout_Horizontal)
msgcont.padding = 5

var msgl = newLabel("Message")
msgl.width = 100
msgl.height = 50
msgl.fontSize = 24
msgcont.add(msgl)

var msg = newTextBox()
msg.height = 50
msg.width = 380
msg.fontSize = 30

msgcont.add(msg)
textcont.add(msgcont)

sendcont.add(textcont)

var btncont = newLayoutContainer(Layout_Vertical)
btncont.padding = 17

var button = newButton("Send Message")
button.onClick = proc(event: ClickEvent) =
    echo "sending"
    client.headers = newHttpHeaders(
        {"Content-Type": "application/json"}
    )
    let body = %*{
        "usr": usr.text,
        "msg": msg.text
    }
    let response = client.request(
                    address, 
                    httpMethod = HttpPost, 
                    body = $body
                   )
    echo response.status

button.height = 115
button.width = 225
button.fontSize = 30

btncont.add(button)
sendcont.add(btncont)

main.add(sendcont)

proc update() =
    {.gcsafe.}:
        var jason: string = client.getContent(address)
        
        var content = parseJson(jason)
        var l: int = len(content)
        if l != reciv:
            for i in reciv..l-1:
                var item = content[i]
                var entry = newLayoutContainer(Layout_Horizontal)
                entry.height = 40
                entry.width = 720

                var eusrl = newLabel($item["usr"].getStr())
                eusrl.width = 200
                eusrl.yScrollPos= 0
                eusrl.heightMode = HeightMode_Expand
                eusrl.fontSize = 30
                eusrl.fontBold = true
                entry.add(eusrl)

                var emsgl = newLabel(" : " & (item["msg"].getStr()))
                emsgl.width = 500
                emsgl.heightMode = HeightMode_Expand
                emsgl.fontSize = 30
                entry.add(emsgl)

                mbox.add(entry)

            reciv = l
            mbox.yScrollPos = -1
        mbox.yScrollPos = -1

        app.sleep(250)
        app.queueMain(update)

proc start() = 
    {.gcsafe.}:
        app.queueMain(update)

window.show()
createThread(thread, start)
app.run()