// *******************************************************

function smilie(thesmilie) {
// inserts smilie text
    var txtarea = document.mvnform.message;
    var newSmilie = ' ' + thesmilie + ' ';
    insertString(txtarea, newSmilie);
}

// *******************************************************

function insertString(txtarea, thetext) {
    if (txtarea.createTextRange && txtarea.caretPos) {
        var caretPos = txtarea.caretPos;
        var newText = thetext;
        if (caretPos.text.charAt(caretPos.text.length - 1) == ' ') newText = newText + ' ';
        if (caretPos.text.charAt(0) == ' ') newText = ' ' + newText;
        caretPos.text = newText;
    } else if (document.getElementById) {
        var selLength = txtarea.textLength;
        var selStart = txtarea.selectionStart;
        var selEnd = txtarea.selectionEnd;
        if (selEnd==1 || selEnd==2) selEnd = selLength;
        var s1 = (txtarea.value).substring(0, selStart);
        var s2 = (txtarea.value).substring(selStart, selEnd)
        var s3 = (txtarea.value).substring(selEnd, selLength);
        var newText = thetext;
        if (s2.charAt(s2.length - 1) == ' ') newText = newText + ' ';
        if (s2.charAt(0) == ' ') newText = ' ' + newText;
        txtarea.value = s1 + thetext + s3;
    } else {
        txtarea.value += thetext;
    }
    txtarea.focus();
}
