<%@page import="org.semanticwb.portal.resources.sem.calendar.CalendarSubscription"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.text.*,org.w3c.dom.*,org.semanticwb.SWBUtils,org.semanticwb.portal.api.*,org.semanticwb.portal.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="java.util.ArrayList,java.util.Comparator,org.semanticwb.platform.*"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%
    SWBResourceURL url = paramRequest.getRenderUrl().setMode("change");
    SWBResourceURL url2 = paramRequest.getRenderUrl();
    SWBResourceURL urlSave = paramRequest.getActionUrl();
    User user = paramRequest.getUser();
    url.setCallMethod(SWBResourceURL.Call_DIRECT);
    String [] days = {
        paramRequest.getLocaleString("lb_day1"),
        paramRequest.getLocaleString("lb_day2"),
        paramRequest.getLocaleString("lb_day3"),
        paramRequest.getLocaleString("lb_day4"),
        paramRequest.getLocaleString("lb_day5"),
        paramRequest.getLocaleString("lb_day6"),
        paramRequest.getLocaleString("lb_day7")
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
    var datos1;

    function desplegar(month, year) {
        var listToolTip = new Array();
        if (window.XMLHttpRequest) {
            peticion_http = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
            peticion_http = new ActiveXObject("Microsoft.XMLHTTP");
        }
        var url = "<%=url%>";

        url += "?month=" + escape(month) + "&year=" + escape(year); 
        peticion_http.open('POST', url, true);
        peticion_http.onreadystatechange = function() {
            if ((peticion_http.readyState == 4) && (peticion_http.status == 200)) {
                var calendar = peticion_http.responseText;
                datos1 = eval('(' + calendar + ')');
                var firstDate = new Date(String(month) + "/1/" + String(year));
                var firstDay = firstDate.getUTCDay();
                var value = 0;
                if (firstDay == 0) {
                    value = 7;
                } else {
                    value = firstDay;
                }
                for (var Elemento in datos1) {
                    var ido2 = new Number(value);
                    var ido = new Number(Elemento);
                    ido = ido + ido2 -1;
                    var object = document.getElementById('eventCal'+ido);
                    var dataEvent = "";
                    var l = 0;
                    var arrayEvts = new Array();
                    var mm = 0 ;
                    for (var Eventos1 in datos1[Elemento]) {
                        arrayEvts[mm] = datos1[Elemento][Eventos1].title;
                        mm = mm + 1 ;
                    }
                   if (arrayEvts.length > 0) {
                       var i = Math.ceil(Math.random()*arrayEvts.length)-1;
                       var name = "eventCal" + ido + "_Event" + 0;
                       l = l + 1;
                        var length = listToolTip.length;
                        var urlEv = datos1[Elemento][arrayEvts[i]].url;
                        var target = "";
                        if(datos1[Elemento][arrayEvts[i]].target != null && datos1[Elemento][arrayEvts[i]].target != "") {
                            target = "target='" + datos1[Elemento][arrayEvts[i]].target + "' ";
                        }
                        if (urlEv!="") {
                            dataEvent = dataEvent + "<a "+ target +"href=\"" + urlEv + "\" id=\"" + name + "\" class=\"txtCalendarBox\">+" +
                                datos1[Elemento][arrayEvts[i]].title + "</a><br>";
                        } else {
                            dataEvent = dataEvent + "<span id=\"" + name + "\" class=\"txtCalendarBox\"><em>+" +
                                datos1[Elemento][arrayEvts[i]].title + "</em></span><br>";
                        }
                        listToolTip[length] = name;
                        var img = datos1[Elemento][arrayEvts[i]].image;
                        var dataName = "";
                        var descr = datos1[Elemento][arrayEvts[i]].description;
                        descr=descr.replace (/\n/g,"<br>");
                        if (img != "") {
                            dataName = "<div class='tooltip'><h1>" + datos1[Elemento][arrayEvts[i]].title + "</h1> <img src='" + datos1[Elemento][arrayEvts[i]].image + "'/> <p>" + datos1[Elemento][arrayEvts[i]].rdates + "</p><p>" + descr + "</p></div>";
                        } else {
                            dataName = "<div class='tooltip'><h1>" + datos1[Elemento][arrayEvts[i]].title + "</h1><p>" + datos1[Elemento][arrayEvts[i]].rdates + "</p><p>" + descr + "</p></div>";
                        }
                        listToolTip[length+1] = dataName;
                    }
                    if (arrayEvts.length > 1) {
                       dataEvent = dataEvent + "<p class='moreEvts'><a href='javascript:showMoreEv(" + Elemento + ")'><%=paramRequest.getLocaleString("lb_viewMore")%></a></p>";
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
        peticion_http.send(null);
    }

    function back() {
        var remEvts = parent.document.getElementById("showPopUpEvts");
        parent.document.body.removeChild(remEvts);
    }

    function showMoreEv(data) {
         //Ordena Datos
        var arrayEvts = new Array();
        var mm =0 ;
        for (var Eventos1 in datos1[data]) {
            arrayEvts[mm] = datos1[data][Eventos1].title;
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
            var url = datos1[data][arrayEvts[i]].url;
            var title = datos1[data][arrayEvts[i]].title;
            var rdates = datos1[data][arrayEvts[i]].rdates;
            var description = datos1[data][arrayEvts[i]].description;
            var image = datos1[data][arrayEvts[i]].image;
            var target = "";
            if(datos1[data][arrayEvts[i]].target != null && datos1[data][arrayEvts[i]].target != "") {
                target = "target='" + datos1[data][arrayEvts[i]].target + "' ";
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
</script>
<div id="containerGral">
    <div class="calendar">
    <script type="text/javascript">
    <!--
        var today = new Date();
        var todaysDay = today.getDay() + 1;
        var todaysDate = today.getDate();
        todaysMonth = today.getMonth() + 1;

        var todaysYear = today.getFullYear();
        
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

        var date = new Date();
        var day = date.getDate();
        var month = date.getMonth() + 1;
        var yy = date.getYear();
        var year = (yy < 1000) ? yy + 1900 : yy;
        var semana = date.getDay();
        var lastDate = new Date(String(month) + "/" + lastDayOfMonth(month, year) + "/" + String(year));

        function changeMonth(buttonpressed) {
            day = date.getDate();
            var auxMonth = month;
            var auxYear = year;

            if (buttonpressed == "prevmonth") {
                month--;
            } else if (buttonpressed == "nextmonth") {
                month++;
            } else  if (buttonpressed == "return" || buttonpressed == "") {
                month = todaysMonth;
                year = todaysYear;
            }
            if (month == 0) {
                month = 12;
                year--;
            } else if (month == 13) {
                month = 1;
                year++
            }
            var lastDayMonth = lastDayOfMonth(month, year);
            if (day > lastDayMonth) {
                day = lastDayMonth;
            }
            if (year <= <%=maxYear%> && year >= <%=minYear%>) {
                var firstDate = new Date(String(month) + "/1/" + String(year));
                var firstDay = firstDate.getUTCDay();
                var lastDate = new Date(String(month) + "/" + lastDayOfMonth(month, year) + "/" + String(year));
                var numbDays = lastDate.getDate();

                for (var i = 1 ; i < 43; i++) {
                    var cel = document.getElementById("Cal" + i);
                    cel.setAttribute("class", "calendarBox empty");
                    var cleanCel = "<div class='day'></div> <div class='events' id='eventCal"+i+"'></div>";
                    cel.innerHTML = cleanCel;
                }
                createDays(firstDay,numbDays);
                desplegar(month, year);
                var object = document.getElementById('currentMonth');
                object.innerHTML= day + " " + months[month] + " " + year;
                calculateYear(year);
            } else {
                month = auxMonth;
                year = auxYear;
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

        function calculateYear(valYear) {
            var year = document.getElementById("selectYear");
            if (valYear == "") {
                valYear = todaysYear;
            }
            var yearCurrent = "<span class='textSelectYear'><%=paramRequest.getLocaleString("lb_selectYear")%> </span> <select name='menuSelectYear' id='menuSelectYear' onchange='changeYear()'>"; //this.value
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

        function changeYear() {
            var chanYear = "";
            var y = document.getElementById("menuSelectYear");
            chanYear = y.options[y.selectedIndex].value;
            year = chanYear;
            if (year <= <%=maxYear%> && year >= <%=minYear%>) {
                var firstDate = new Date(String(month) + "/1/" + String(year));
                var firstDay = firstDate.getUTCDay();
                var lastDate = new Date(String(month) + "/" + lastDayOfMonth(month, year) + "/" + String(year));
                var numbDays = lastDate.getDate();
                for (var i = 1 ; i < 43; i++) {
                    var cel = document.getElementById("Cal" + i);
                    cel.setAttribute("class", "calendarBox empty");
                    var cleanCel = "<div class='day'></div> <div class='events' id='eventCal"+i+"'></div>";
                    cel.innerHTML = cleanCel;
                }
                createDays(firstDay, numbDays);
                desplegar(month, year);
                var object = document.getElementById('currentMonth');
                object.innerHTML = day + " " + months[month] + " " + year;
            }
        }

        function createDays(firstDay, numbDays) {
            var value = 0;
            if (firstDay == 0) { value = 7 }
            else if (firstDay == 1) { value = 1 }
            else if (firstDay == 2) { value = 2 }
            else if (firstDay == 3) { value = 3 }
            else if (firstDay == 4) { value = 4 }
            else if (firstDay == 5) { value = 5 }
            else if (firstDay == 6) { value = 6 }
           for (var x = 1; x <= numbDays; x++) {
               var object = document.getElementById('Cal' + value);
               object.setAttribute("class", "calendarBox");
               var addDay = "<div class='day'>" + x + "</div> <div class='events' id='eventCal" + value + "'></div>";
               object.innerHTML = addDay;
               value = value+1;
           }
        }
            --></script>
    <div class="month">
        <div class="monthTitle">
            <div class="containerMonth">
                <span class="imgWidth"><a href="javascript:void(0);" onClick="changeMonth('prevmonth')"><img src="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/images/calendar/btnAnt.png" border="0"/></a></span>
                <span class="currentMonth" id="currentMonth"></span>
                <span class="imgWidth"><a href="javascript:void(0);" onClick="changeMonth('nextmonth')"><img src="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/images/calendar/btnSig.png" border="0"/></a></span>
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
            <div class="calendarBox empty" id="Cal<%=i%>">
                    <div class="day"></div>
                    <div class="events" id="eventCal<%=i%>"></div>
            </div>
    <%}
    %>
    </div>
    <div class="selectYear" id="selectYear">
    </div>
</div>
<div class="optionsUser">
    <div class="selecSubscr">
    <%if(isSubscriptor) {%>
        <a href="<%=urlSave.setAction("saveSubCal").setParameter("uriCancel", uriSubscription)%>"><%=paramRequest.getLocaleString("lb_cancelSubscription")%></a>
    <%} else if(user.isSigned()){%>
        <a href="<%=urlSave.setAction("saveSubCal")%>"><%=paramRequest.getLocaleString("lb_subscription")%></a>
    <%}%>
    </div>
<%    if(user.getRole() != null && roles.contains(user.getRole().getId())) { %>
    <div>
        <a href="<%=url2.setMode("viewEvts")%>"><%=paramRequest.getLocaleString("lb_actEvt")%></a>
    </div>
<%    } %>
</div>
<script type="text/javascript">
    <!--
            dojo.addOnLoad( function(){
                changeMonth(""); calculateYear("");}
            );
    -->
</script>