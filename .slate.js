//  [ PUSH ]
//  [ -Config- ]
var pushUp = slate.operation("push", {
    "direction" : "up",
    "style" : "bar-resize:screenSizeY/2"
});
var pushRight = slate.operation("push", {
    "direction" : "right",
    "style" : "bar-resize:screenSizeX/2"
});
var pushDown = slate.operation("push", {
    "direction" : "down",
    "style" : "bar-resize:screenSizeY/2"
});
var pushLeft = slate.operation("push", {
    "direction" : "left",
    "style" : "bar-resize:screenSizeX/2"
});
//  [ -Binding- ]
slate.bind("w:a,alt", pushUp);
slate.bind("d:a,alt", pushRight);
slate.bind("s:a,alt", pushDown);
slate.bind("a:a,alt", pushLeft);

//  [ THROW ]
//  [ -Config- ]
var throwTo0 = slate.operation("throw", {
    "x"      : 'screenOriginX',
    "y"      : 'screenOriginY',
    "width"  : 'screenSizeX',
    "height" : 'screenSizeY',
    "screen" : '0'
});
var throwTo1 = slate.operation("throw", {
    "x"      : 'screenOriginX',
    "y"      : 'screenOriginY',
    "width"  : 'screenSizeX',
    "height" : 'screenSizeY',
    "screen" : '1'
});
//  [ -Binding- ]
slate.bind("0:f,alt", throwTo0);
slate.bind("1:f,alt", throwTo1);

//  [ FOCUS ]
//  [ -Config- ]
var focusUp = slate.operation("focus", {
    "direction" : "up"
});
var focusRight = slate.operation("focus", {
    "direction" : "right"
});
var focusDown = slate.operation("focus", {
    "direction" : "down"
});
var focusLeft = slate.operation("focus", {
    "direction" : "left"
});
var focusBehind = slate.operation("focus", {
    "direction" : "behind"
});
//  [ -Binding- ]
slate.bind("k:alt", focusUp);
slate.bind("l:alt", focusRight);
slate.bind("h:alt", focusDown);
slate.bind("j:alt", focusLeft);
slate.bind("o:alt", focusBehind);

