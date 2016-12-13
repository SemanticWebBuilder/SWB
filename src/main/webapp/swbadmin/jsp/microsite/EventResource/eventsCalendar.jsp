<%@page contentType="text/html"%>
<%@page import="java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    User user = paramRequest.getUser();
    WebPage wpage = paramRequest.getWebPage();
    MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
    Member member = Member.getMember(user, wpage);
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss a");
    String year = request.getParameter("year");
    String month = request.getParameter("month");
    int imonth = 0;
    String day = request.getParameter("day");
    Date current = new Date(System.currentTimeMillis());

    if(day != null && month != null && day != null) {
        current = new Date(Integer.valueOf(year) - 1900, Integer.valueOf(month), Integer.valueOf(day));
        imonth = Integer.parseInt(month);
    }
%>

<script type="text/javascript">
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.ValidationTextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.Button");
    dojo.require("dijit.form.FilteringSelect");
    dojo.require("dojo.parser");

    function openTooltip(oid, ttid, tip) {
        var o = document.getElementById(oid);
        var coords = dojo.coords(o);

        var tt = document.createElement('div');
        tt.setAttribute('id', ttid);
	tt.setAttribute("style", "position: absolute;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px; line-height:3px; padding-top:10px; color: #000000;background-color: #FFFF99;padding-right: 5px;padding-left: 5px;position: absolute;border: 1px solid #AAAAAA;");
	tt.style.top = (coords.y)+'px';
	tt.style.left = (coords.x+coords.w+2)+'px';
        tt.innerHTML = tip;
        document.body.appendChild(tt);
    }

    function closeTooltip(ttid) {
        var tt = document.getElementById(ttid);
        document.body.removeChild(tt);
    }


</script>

    <form id="calendarForm" action="<%=paramRequest.getRenderUrl().setParameter("act", "calendar")%>" method="post">
        <fieldset><legend>Elige una fecha</legend>
            <label for="year">Año:</label>
            <input type="text" style="width:70px;" regExp="\d{4}" dojoType="dijit.form.ValidationTextBox" name="year" id="year" value="<%=current.getYear() + 1900%>"/>
            <label for="month">Mes:</label>
            <select  style="width:150px;" name ="month" id="month" value="<%=current.getMonth()%>">
                <option value="0" <%= imonth==0?"selected=\"selected\"":""%>>Enero</option>
                <option value="1" <%= imonth==1?"selected=\"selected\"":""%>>Febrero</option>
                <option value="2" <%= imonth==2?"selected=\"selected\"":""%>>Marzo</option>
                <option value="3" <%= imonth==3?"selected=\"selected\"":""%>>Abril</option>
                <option value="4" <%= imonth==4?"selected=\"selected\"":""%>>Mayo</option>
                <option value="5" <%= imonth==5?"selected=\"selected\"":""%>>Junio</option>
                <option value="6" <%= imonth==6?"selected=\"selected\"":""%>>Julio</option>
                <option value="7" <%= imonth==7?"selected=\"selected\"":""%>>Agosto</option>
                <option value="8" <%= imonth==8?"selected=\"selected\"":""%>>Septiembre</option>
                <option value="9" <%= imonth==9?"selected=\"selected\"":""%>>Octubre</option>
                <option value="10" <%= imonth==10?"selected=\"selected\"":""%>>Noviembre</option>
                <option value="11" <%= imonth==11?"selected=\"selected\"":""%>>Diciembre</option>
            </select>
            <input type="hidden" name="day" id="day" value="1"/>
            <input type="submit" id="calendarSubmit" label="Ir" value="Ir"/>
        </fieldset>
    </form>

    <%=renderCalendar(current, wpage, paramRequest)%>
    <%SWBResourceURL rUrl = paramRequest.getRenderUrl().setParameter("act", "view");%>
    <a href="<%=rUrl%>">Regresar a la lista de eventos</a>
<%!
    private String renderCalendar(Date current, WebPage wpage, SWBParamRequest paramRequest) {
        String resId = paramRequest.getResourceBase().getId();
        StringBuilder sbf = new StringBuilder();

        //If no date specified, get current date
        if (current == null) current = new Date(System.currentTimeMillis());

        int day = current.getDate();
        int month = current.getMonth();
        int year = current.getYear();

        String [] months = {"Enero", "Febrero", "Marzo", "Abril",
                            "Mayo", "Junio", "Julio", "Agosto",
                            "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        String [] days = {"D", "L", "M", "M", "J", "V", "S"};

        Date thisMonth = new Date(year, month, 1);
        Date nextMonth = new Date(year, month + 1, 1);

        //Find out when this mont starts and ends
        int firstWeekDay = thisMonth.getDay();
        long daysInMonth = Math.round((nextMonth.getTime() - thisMonth.getTime()) / (1000 * 60 * 60 * 24));
        SWBResourceURL nml = paramRequest.getRenderUrl().setParameter("act", "calendar");
        nml.setParameter("year", String.valueOf(year + 1900));
        nml.setParameter("month", String.valueOf(month + 1));
        nml.setParameter("day", "1");

        SWBResourceURL pml = paramRequest.getRenderUrl().setParameter("act", "calendar");
        pml.setParameter("year", String.valueOf(year + 1900));
        pml.setParameter("month", String.valueOf(month - 1));
        pml.setParameter("day", "1");

        sbf.append("\n" +
                "  <div id=\"calendario\">\n" +
                "      <h2><a href=\"" + pml + "\">&lt;</a>    " + months[month] + " " + (year + 1900) + "    <a href=\"" + nml + "\">&gt;</a>" +
                "</h2>\n");

        //Render day labels
        sbf.append("<ul class=\"dias semana\">\n");
        for (int i = 0; i < 7; i++) {
            sbf.append("      <li>" + days[i] + "</li>\n");
        }
        sbf.append("    </ul>\n");

        sbf.append("<ul class=\"dias\">\n");
        //Fill the first week in the month with the appropiate day offset
        for (int i = 0; i < firstWeekDay; i++) {
            sbf.append("      <li>&nbsp;</li>\n");
        }

        int weekDay = firstWeekDay;
        for (int i = 1; i <= daysInMonth; i++) {
            Iterator<EventElement> evsNow = EventElement.listEventElementsByDate(null, new Date(year, month, i), wpage, wpage.getWebSite());

            String eventTitles = "";
            while (evsNow.hasNext()) {
                EventElement eve = evsNow.next();
                eventTitles = eventTitles + "<p>" + eve.getTitle().trim() + "</p>";
            }

            //Today?
            if (day == i - 1) {
                //Are there events today?
                if (!eventTitles.equals("")) {
                    SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "daily");
                    viewUrl.setParameter("year", String.valueOf(year + 1900));
                    viewUrl.setParameter("month", String.valueOf(month));
                    viewUrl.setParameter("day", String.valueOf(i));

                    sbf.append("<li id=\"td_"+i+resId+"\">\n");
                    sbf.append("  <a href=\""+viewUrl+"\" onmouseover=\"openTooltip('td_"+i+resId+"','tt_"+i+resId+"','"+eventTitles+"')\" onmouseout=\"closeTooltip('tt_"+i+resId+"')\">" + i + "</a>\n");
                    sbf.append("</li>\n");
                }  else {
                    //There aren't events today
                    sbf.append("<li>\n" + i + "</li>\n");
                }
            } else {
                //Not today
                evsNow = EventElement.listEventElementsByDate(null, new Date(year, month, i), wpage, wpage.getWebSite());
                if (!eventTitles.equals("")) {
                    SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "daily");
                    viewUrl.setParameter("year", String.valueOf(year + 1900));
                    viewUrl.setParameter("month", String.valueOf(month));
                    viewUrl.setParameter("day", String.valueOf(i));

                    sbf.append("<li id=\"td_"+i+resId+"\">\n");
                    sbf.append("  <a href=\""+viewUrl+"\"  onmouseover=\"openTooltip('td_"+i+resId+"','tt_"+i+resId+"','"+eventTitles+"')\" onmouseout=\"closeTooltip('tt_"+i+resId+"')\">" + i + "</a>\n");
                    sbf.append("</li>\n");
                } else {
                    sbf.append("<li>\n" + i + "</li>\n");
                }
            }
            weekDay++;
        }
        for(int i = 0; i < (7-weekDay); i++) {
            sbf.append("<li>&nbsp</li>\n");
        }
        sbf.append("</ul>\n");
        sbf.append("</div>\n");
        sbf.append("<div class=\"clear\">&nbsp;</div>");
        return sbf.toString();
    }
%>