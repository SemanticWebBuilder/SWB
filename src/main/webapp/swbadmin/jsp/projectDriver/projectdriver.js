/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor. 
 */
function validar(forma,array){
    var val=true;
    x = new Array();
    x=array;
    var str=x.toString();
    if(str.length>0){
        var str1=str.split(",");
    }
    var msg1 = str1[0].substring(1, str1[0].length);
    var msg2 = str1[1];
    var msg3 = str1[2];
    var msg4 = str1[3];
    var msg5 = str1[4];
    var msg6 = str1[5];
    var msg7 = str1[6].substring(0, str1[6].length-1);

    if(forma.status.value=='develop'){
        if(forma.plannedHour.value==""||forma.plannedHour.value==0){
            alert(msg1);
            forma.plannedHour.focus();
            val = false;
        }
        if(forma.currentHour.value==""){
            alert(msg2);
            forma.currentHour.focus();
            val=false;
        }
        if(forma.currentPercentage.value==""){
            alert(msg3);
            forma.currentPercentage.focus();
            val =false;
        }
    }else if(forma.status.value=='ended'||forma.status.value=='paused'){
        if(forma.plannedHour.value==""||forma.plannedHour.value==0){
            alert(msg1);
            forma.plannedHour.focus();
            val = false;
        }
        if(forma.currentHour.value==""||forma.currentHour.value==0){
            alert(msg2);
            forma.currentHour.focus();
            val=false;
        }
        if(forma.currentPercentage.value==""||forma.currentPercentage.value==0){
            alert(msg3);
            forma.currentPercentage.focus();
            val =false;
        }
        if(forma.status.value=='ended'){
            forma.currentPercentage.value=100;
        }
    }else if(forma.status.value=='assigned'){
        forma.currentPercentage.value=0;
        forma.currentHour.value=0;
    }
    if(forma.plannedHour.value!=""&&isNaN(forma.plannedHour.value)==true){
        alert(msg4);
        val=false;
    }
    if(forma.plannedHour.value<0||forma.currentHour.value<0||forma.currentPercentage.value<0){
        alert(msg7);
        val=false;
    }
    if(forma.currentHour.value!=""&&isNaN(forma.currentHour.value)==true){
        alert(msg5);
        val=false;
    }
    if(forma.currentPercentage.value!=""&&isNaN(forma.currentPercentage.value)==true){
        alert(msg6);
        val=false;
    }
    return val;
}

function hideDiv(objDIV) {
    document.getElementById(objDIV).style.visibility = 'hidden';
}

function showDiv(objDIV) {
    document.getElementById(objDIV).style.visibility = 'visible';
}

function calcular(forma){
    var pH=forma.plannedHour.value;
    var cH=forma.currentHour.value;
    if(pH>0&&cH>0){
        var res=(cH/pH)*100;
        forma.currentPercentage.value=res.toFixed(2);
    }
}



