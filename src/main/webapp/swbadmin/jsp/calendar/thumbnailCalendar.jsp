<%-- 
    Document   : thumbnailCalendar
    Created on : 16/05/2011, 03:53:55 PM
    Author     : martha.jimenez
--%>
<%@page import="org.semanticwb.portal.resources.sem.calendar.CalendarSubscription"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.text.*,org.w3c.dom.*,org.semanticwb.SWBUtils,org.semanticwb.portal.api.*,org.semanticwb.portal.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="java.util.ArrayList,java.util.Comparator,org.semanticwb.platform.*"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%
    SWBResourceURL url = paramRequest.getRenderUrl().setMode("change");
    User user = paramRequest.getUser();
    url.setCallMethod(SWBResourceURL.Call_DIRECT);
    String [] days = {
        paramRequest.getLocaleString("lb_day1_2"),
        paramRequest.getLocaleString("lb_day2_2"),
        paramRequest.getLocaleString("lb_day3_2"),
        paramRequest.getLocaleString("lb_day4_2"),
        paramRequest.getLocaleString("lb_day5_2"),
        paramRequest.getLocaleString("lb_day6_2"),
        paramRequest.getLocaleString("lb_day7_2")
    };
    Resource base = paramRequest.getResourceBase();
    SWBResource wbBase = SWBPortal.getResourceMgr().getResource(base);
    SemanticObject objn = ((GenericSemResource)wbBase).getSemanticObject();
    org.semanticwb.portal.resources.sem.calendar.Calendar cal = (org.semanticwb.portal.resources.sem.calendar.Calendar) objn.createGenericInstance();

    Date date = new Date();
    int minYear = (date.getYear() < 1000) ? date.getYear() + 1900 : date.getYear();
    int maxYear = minYear;
    if (cal.isPreviousYear()) {
        minYear = minYear - 1;
    }
    if (cal.isNextYear()) {
        maxYear = maxYear + 1;
    }
    Iterator <CalendarSubscription> subs = CalendarSubscription.ClassMgr.listCalendarSubscriptionByCalendarSubscription(cal);
    boolean isSubscriptor = false;
    String uriSubscription = "";
    while(subs.hasNext()) {
        CalendarSubscription subscription = subs.next();
        if(subscription.getUserCalendarSubscription() != null) {
            User userSubs = subscription.getUserCalendarSubscription();
            if(userSubs.equals(user)) {
                isSubscriptor = true;
                uriSubscription = subscription.getEncodedURI();
            }
        }
    }
    ArrayList roles = new ArrayList();
    String getRole1 = cal.getRoleForAdmin();
    while(getRole1 != null && getRole1.trim().length() > 1) {
        int num = getRole1.indexOf(",");
        if(num == -1 && getRole1.length() > 1) {
            roles.add(getRole1.trim());
            break;
        } else {
            String data1 = getRole1.substring(0, num);
            if(data1.trim().length() > 1) {
                roles.add(data1.trim());
            }
            num = num + 1;
            getRole1 = getRole1.substring(num ,getRole1.length());
            if(getRole1.indexOf(",") == -1) {
                if(getRole1.trim().length() > 1) {
                    roles.add(getRole1.trim());
                }
                break;
            }
        }
    }
%>
<link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/css/calendar.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    dojo.require("dijit.Tooltip");
    var datos1_<%=cal.getId()%>_thum;

    function desplegar<%=cal.getId()%>_tumb(month, year) {
        var listToolTip = new Array();
        if (window.XMLHttpRequest) {
            peticion_http<%=cal.getId()%>_tumb = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            peticion_http<%=cal.getId()%>_tumb = new ActiveXObject("Microsoft.XMLHTTP");
        }
        var url = "<%=url%>";

        url += "?month=" + escape(month) + "&year=" + escape(year);
        peticion_http<%=cal.getId()%>_tumb.open('POST', url, true);
        peticion_http<%=cal.getId()%>_tumb.onreadystatechange = function() {
            if ((peticion_http<%=cal.getId()%>_tumb.readyState == 4) && (peticion_http<%=cal.getId()%>_tumb.status == 200)) {
                var calendar = peticion_http<%=cal.getId()%>_tumb.responseText;
                datos1_<%=cal.getId()%>_thum = eval('(' + calendar + ')');
                var firstDate = new Date(String(month) + "/1/" + String(year));
                var firstDay = firstDate.getUTCDay();
                var value = 0;
                if (firstDay == 0) {
                    value = 7;
                } else {
                    value = firstDay;
                }
                for (var Elemento in datos1_<%=cal.getId()%>_thum) {
                    var ido2 = new Number(value);
                    var ido = new Number(Elemento);
                    ido = ido + ido2 -1;
                    var object = document.getElementById('<%=cal.getId()%>_thumeventCal'+ido);
                    var dataEvent = "";
                    var l = 0;
                    var arrayEvts = new Array();
                    var mm = 0 ;
                    for (var Eventos1 in datos1_<%=cal.getId()%>_thum[Elemento]) {
                        arrayEvts[mm] = datos1_<%=cal.getId()%>_thum[Elemento][Eventos1].title;
                        mm = mm + 1 ;
                    }
                    var array = new Array();
                    array[0] = Elemento;
                    array[1] = '"<%=cal.getId()%>"';
                    array[2] = '"1"'  ;
                    if (arrayEvts.length > 0) {
                       dataEvent = dataEvent + "<p class='moreEvtsThumb'><a href='javascript:showMoreEv<%=cal.getId()%>_thum("  + array.join(",").toString() + ")'><%--=paramRequest.getLocaleString("lb_viewMore")--%>+</a></p>";
                    }
                    object.innerHTML = dataEvent;
                }
                for (var i = 0; i < listToolTip.length;i = i + 2) {
                    new dijit.Tooltip({
                        connectId: [listToolTip[i]],
                        label: listToolTip[i+1]
                    });
                }
            }
        }
        peticion_http<%=cal.getId()%>_tumb.send(null);
    }

    function back() {
        var remEvts = parent.document.getElementById("showPopUpEvts");
        parent.document.body.removeChild(remEvts);
    }

    function showMoreEv<%=cal.getId()%>_thum(data, id, tum) {
         //Ordena Datos
        var arrayEvts = new Array();
        var mm =0 ;

        if(id == <%=cal.getId()%>) {
            for (var Eventos1 in datos1_<%=cal.getId()%>_thum[data]) {
                arrayEvts[mm] = datos1_<%=cal.getId()%>_thum[data][Eventos1].title;
                mm = mm + 1 ;
            }
            arrayEvts.sort();

            var listToolTip = new Array();
            var evts = document.createElement('div');
            evts.id = 'showPopUpEvts';
            evts.className = 'showPopUpEvts'
            var s = "";
            s = s.concat("  <div class='opBackground'></div>");
            s = s.concat("<div class='containerEvts'>");
            s = s.concat("<div class='allPopUpEvts'>");
            s = s.concat("<div class='showPopUp'>");
            s = s.concat("<p class=\"day2\">" + data + "</p>");
            var lT = -1;
            s = s.concat("<div class='showPopUpAllEvts'>");
            for (var i = 0; i < arrayEvts.length; i++) {
                var url = datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].url; 
                var title = datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].title;
                var rdates = datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].rdates;
                var description = datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].description;
                var image = datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].image;
                var target = "";
                if(datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].target != null && datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].target != "") { 
                    target = "target='" + datos1_<%=cal.getId()%>_thum[data][arrayEvts[i]].target + "' ";
                }
                var name = "_eventCal" + data + "_Event" + i;
                lT = lT + 1;
                listToolTip[lT] = name;
                var lbl = "";
                if (image != "") {
                    lbl = "<div class='tooltip1'><h1>" + title + "</h1> <img src='" + image + "'/> <p>" + rdates + "</p><p>" + description + "</p></div>";
                } else {
                    lbl = "<div class='tooltip1'><h1>" + title + "</h1><p>" + rdates + "</p><p>" + description + "</p></div>";
                }

                lT = lT + 1;
                listToolTip[lT] = lbl;

                if (url != "") {
                    s = s.concat("<a " +target+"href=\"" + url + "\" id=\"" + name + "\" class=\"txtCalendarBox\">+ " + title + "</a><br>");
                } else {
                    s = s.concat("<span id=\"" + name + "\" class=\"txtCalendarBox\"><em>+ " + title + "</em></span><br>");
                }
            }

            s = s.concat("</div>");
            s = s.concat("<p align='center'>");
            s = s.concat("<input type='submit' name='regresar' onclick='back()' value='<%=paramRequest.getLocaleString("lb_return")%>'/>");
            s = s.concat("</p>");
            s = s.concat("</div>");//termina showPopUp

            s = s.concat("</div>");//termina allPopUpEvts
            s = s.concat("</div>");//termina containerEvts
            evts.innerHTML = s;
            document.body.appendChild(evts);
            for (var i = 0; i < listToolTip.length; i = i + 2) {
                new dijit.Tooltip({
                    connectId: [listToolTip[i]],
                    label: listToolTip[i+1]
                });
            }
        }
    }
</script>
<div id="containerGralThum">
    <div class="Thumbnailcalendar">
    <script type="text/javascript">
    <!--
        var date = new Date();
        todaysMonth = date.getMonth() + 1;
        var todaysYear = date.getFullYear();
        var day = date.getDate();
        var month<%=cal.getId()%>_tumb = date.getMonth() + 1;
        var yy = date.getYear();
        var year<%=cal.getId()%>_tumb = (yy < 1000) ? yy + 1900 : yy;

        function makeArray() {
            for (i = 0; i < makeArray.arguments.length; i++)
                    this[i + 1] = makeArray.arguments[i];
        }


        var months = new makeArray("<%=paramRequest.getLocaleString("lb_month1")%>",
                                   "<%=paramRequest.getLocaleString("lb_month2")%>",
                                   "<%=paramRequest.getLocaleString("lb_month3")%>",
                                   "<%=paramRequest.getLocaleString("lb_month4")%>",
                                   "<%=paramRequest.getLocaleString("lb_month5")%>",
                                   "<%=paramRequest.getLocaleString("lb_month6")%>",
                                   "<%=paramRequest.getLocaleString("lb_month7")%>",
                                   "<%=paramRequest.getLocaleString("lb_month8")%>",
                                   "<%=paramRequest.getLocaleString("lb_month9")%>",
                                   "<%=paramRequest.getLocaleString("lb_month10")%>",
                                   "<%=paramRequest.getLocaleString("lb_month11")%>",
                                   "<%=paramRequest.getLocaleString("lb_month12")%>");

        function changeMonth<%=cal.getId()%>_tumb(buttonpressed) {
            day = date.getDate();

            var auxMonth = month<%=cal.getId()%>_tumb;
            var auxYear = year<%=cal.getId()%>_tumb;

            if (buttonpressed == "prevmonth") {
                month<%=cal.getId()%>_tumb--;
            } else if (buttonpressed == "nextmonth") {
                month<%=cal.getId()%>_tumb++;
            } else  if (buttonpressed == "return" || buttonpressed == "") {
                month<%=cal.getId()%>_tumb = todaysMonth;
                year<%=cal.getId()%>_tumb = todaysYear;
            }
            if (month<%=cal.getId()%>_tumb == 0) {
                month<%=cal.getId()%>_tumb = 12;
                year<%=cal.getId()%>_tumb--;
            } else if (month<%=cal.getId()%>_tumb == 13) {
                month<%=cal.getId()%>_tumb = 1;
                year<%=cal.getId()%>_tumb++
            }
            var lastDayMonth = lastDayOfMonth(month<%=cal.getId()%>_tumb, year<%=cal.getId()%>_tumb);
            if (day > lastDayMonth) {
                day = lastDayMonth;
            }
            if (year<%=cal.getId()%>_tumb <= <%=maxYear%> && year<%=cal.getId()%>_tumb >= <%=minYear%>) {
                var firstDate = new Date(String(month<%=cal.getId()%>_tumb) + "/1/" + String(year<%=cal.getId()%>_tumb));
                var firstDay = firstDate.getUTCDay();
                var lastDate = new Date(String(month<%=cal.getId()%>_tumb) + "/" + lastDayOfMonth(month<%=cal.getId()%>_tumb, year<%=cal.getId()%>_tumb) + "/" + String(year<%=cal.getId()%>_tumb));
                var numbDays = lastDate.getDate();

                for (var i = 1 ; i < 43; i++) {
                    var cel = document.getElementById("<%=cal.getId()%>_thum" +'Cal' + i);
                    cel.setAttribute("class", "calendarBoxThumb empty");
                    var cleanCel = "<div class='day'></div> <div class='eventsThumb' id='<%=cal.getId()%>_thumeventCal"+i+"'></div>";
                    cel.innerHTML = cleanCel;
                }
                createDays<%=cal.getId()%>_tumb(firstDay,numbDays);
                
                desplegar<%=cal.getId()%>_tumb(month<%=cal.getId()%>_tumb, year<%=cal.getId()%>_tumb);
                var object = document.getElementById('<%=cal.getId()%>_thumcurrentMonth');
                object.innerHTML= day + " " + months[month<%=cal.getId()%>_tumb] + " " + year<%=cal.getId()%>_tumb;
                calculateYear<%=cal.getId()%>_tumb(year<%=cal.getId()%>_tumb);
            } else {
                month<%=cal.getId()%>_tumb = auxMonth;
                year<%=cal.getId()%>_tumb = auxYear;
            }
        }

        function lastDayOfMonth(month,year) {
            var day = 0;
            switch(month)
            {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    day = 31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    day = 30;
                    break;
                case 2:
                    if((year % 4 == 0)||((year % 100 == 0) && (year % 400 == 0))) {
                        day = 29;
                    } else {
                        day = 28;
                    }
            }
            return day;
        }

        function calculateYear<%=cal.getId()%>_tumb(valYear) {
            var year = document.getElementById("<%=cal.getId()%>_tumbselectYearTumb");
            if (valYear == "") {
                valYear = todaysYear;
            }
            var yearCurrent = "<span class='textSelectYear'><%=paramRequest.getLocaleString("lb_selectYear")%> </span> <select name='menuSelectYear' id='<%=cal.getId()%>_tumbmenuSelectYearTumb' onchange='changeYear<%=cal.getId()%>_tumb()'>"; //this.value
            for (var i = <%=minYear%>; i <= <%=maxYear%>; i++) {
                yearCurrent = yearCurrent + "<option";
                if(i == valYear) {
                    yearCurrent = yearCurrent + " selected='selected'";
                }
                yearCurrent=yearCurrent + ">"+i+"</option>";
            }
            yearCurrent = yearCurrent + "</select>";
            year.innerHTML = yearCurrent;
        }

        function changeYear<%=cal.getId()%>_tumb() {
            var chanYear = "";
            var y = document.getElementById("<%=cal.getId()%>_tumbmenuSelectYearTumb");
            chanYear = y.options[y.selectedIndex].value;
            year<%=cal.getId()%>_tumb = chanYear;
            if (year<%=cal.getId()%>_tumb <= <%=maxYear%> && year<%=cal.getId()%>_tumb >= <%=minYear%>) {
                var firstDate = new Date(String(month<%=cal.getId()%>_tumb) + "/1/" + String(year<%=cal.getId()%>_tumb));
                var firstDay = firstDate.getUTCDay();
                var lastDate = new Date(String(month<%=cal.getId()%>_tumb) + "/" + lastDayOfMonth(month<%=cal.getId()%>_tumb, year<%=cal.getId()%>_tumb) + "/" + String(year<%=cal.getId()%>_tumb));
                var numbDays = lastDate.getDate();
                for (var i = 1 ; i < 43; i++) {
                    var cel = document.getElementById("<%=cal.getId()%>_thumCal" + i);
                    cel.setAttribute("class", "calendarBoxThumb empty");
                    var cleanCel = "<div class='day'></div> <div class='eventsThumb' id='<%=cal.getId()%>_thumeventCal"+i+"'></div>";
                    cel.innerHTML = cleanCel;
                }
                createDays<%=cal.getId()%>_tumb(firstDay, numbDays);
                desplegar<%=cal.getId()%>_tumb(month<%=cal.getId()%>_tumb, year<%=cal.getId()%>_tumb);
                var object = document.getElementById('<%=cal.getId()%>_thumcurrentMonth');
                object.innerHTML = day + " " + months[month<%=cal.getId()%>_tumb] + " " + year<%=cal.getId()%>_tumb;
            }
        }

        function createDays<%=cal.getId()%>_tumb(firstDay, numbDays) {
            var value = 0;
            if (firstDay == 0) { value = 7 }
            else if (firstDay == 1) { value = 1 }
            else if (firstDay == 2) { value = 2 }
            else if (firstDay == 3) { value = 3 }
            else if (firstDay == 4) { value = 4 }
            else if (firstDay == 5) { value = 5 }
            else if (firstDay == 6) { value = 6 }
           for (var x = 1; x <= numbDays; x++) {
               var object = document.getElementById('<%=cal.getId()%>_thumCal' + value);
               object.setAttribute("class", "calendarBoxThumb");
               var addDay = "<div class='day'>" + x + "</div> <div class='eventsThumb' id='<%=cal.getId()%>_thumeventCal" + value + "'></div>";
               object.innerHTML = addDay;
               value = value+1;
           }
        }
            --></script>
    <div class="month">
        <div class="monthTitle">
            <div class="containerMonthTumb">
                <span class="imgWidthTumb"><a href="javascript:void(0);" onClick="changeMonth<%=cal.getId()%>_tumb('prevmonth')"><img src="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/images/calendar/img2.png" border="0"/></a></span>
                <span class="currentMonthTumb" id="<%=cal.getId()%>_thumcurrentMonth"></span>
                <span class="imgWidthTumb"><a href="javascript:void(0);" onClick="changeMonth<%=cal.getId()%>_tumb('nextmonth')"><img src="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/images/calendar/img1.png" border="0"/></a></span>
            </div>
        </div>
    </div>
    <div class="weekdays">
    <%
    for (int i = 0; i < days.length; i++) {%>
        <p><%=days[i]%></p>
    <%}%>
    </div>
    <%for (int i = 1; i < 43; i++) {%>
            <div class="calendarBoxThumb empty" id="<%=cal.getId()%>_thumCal<%=i%>">
                    <div class="day"></div>
                    <div class="eventsThumb" id="<%=cal.getId()%>_thumeventCal<%=i%>"></div>
            </div>
    <%}
    %>
    </div>
    <div class="selectYearTumb" id="<%=cal.getId()%>_tumbselectYearTumb">
    </div>
</div>
<script type="text/javascript">
    <!--
            dojo.addOnLoad( function(){
                changeMonth<%=cal.getId()%>_tumb(""); calculateYear<%=cal.getId()%>_tumb("");}
            );
    -->
</script>