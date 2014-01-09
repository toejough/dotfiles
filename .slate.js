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
slate.bind("w:alt", pushUp);
slate.bind("d:alt", pushRight);
slate.bind("s:alt", pushDown);
slate.bind("a:alt", pushLeft);

//  [ THROW ]
//  [ -Config- ]
var throwToCurrent = slate.operation("throw", {
    "x"      : 'screenOriginX',
    "y"      : 'screenOriginY',
    "width"  : 'screenSizeX',
    "height" : 'screenSizeY',
    "screen" : 'currentID'
});
//  [ -Binding- ]
slate.bind("f:alt", throwToCurrent);

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

//  [ RELOAD ]
//  [ -Config- ]
var relaunch = slate.operation("relaunch");
//  [ -Binding- ]
slate.bind("r:alt", relaunch);

//  [ GRID ]
//  [ -Config- ]
var grid = slate.operation("grid", {
    "grids" : {
        "2880x1800" : {
            "width" : 6
            "height" : 2
        },
    },
    "padding" : 5
});
//  [ -Binding- ]
slate.bind("g:alt", grid);
