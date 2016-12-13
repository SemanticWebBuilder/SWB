<%@page import="java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    dojo.require("dijit.Tooltip");
    dojo.require("dojo.parser");    
</script>

    <%
SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
User user=paramRequest.getUser();
String lang="es";
WebPage wpage = paramRequest.getWebPage();
if(user.getLanguage()!=null) lang=user.getLanguage();

String year = request.getParameter("y");
String month = request.getParameter("m");
String day = request.getParameter("d");
Date current = new Date(System.currentTimeMillis());

if (year != null && month != null && day != null) {
    current = new Date(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
}

%><div style="text-align:center"><%=renderCalendar(user, current, wpage, paramRequest)%>
    <p class="vermas">
    <a href ="<%=request.getAttribute("admurl")%>">Ver todos</a>
</p>
</div>
<%!
    private String renderCalendar(User user, Date current, WebPage wpage, SWBParamRequest paramRequest) {
        StringBuffer sbf = new StringBuffer();

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

        //TODO:eliminar el día de la fecha, obviarlo a 1 para mostrar todos los eventos del mes
        SWBResourceURL nml = paramRequest.getRenderUrl();
        nml.setParameter("y", String.valueOf(year));
        nml.setParameter("m", String.valueOf(month + 1));
        nml.setParameter("d", "1");

        SWBResourceURL pml = paramRequest.getRenderUrl();
        pml.setParameter("y", String.valueOf(year));
        pml.setParameter("m", String.valueOf(month - 1));
        pml.setParameter("d", "1");

        sbf.append("<div class=\"calendar\">\n" +
                "  <table>\n" +
                "    <tr>\n" +
                "      <td class=\"month-head\" colspan=\"7\">" +
                "<a href=\"" + pml + "\">&lt;</a>    " +
                months[month] + " " + (year + 1900) +
                "    <a href=\"" + nml + "\">&gt;</a>" +
                "</td>\n" +
                "    </tr>\n" +
                "    <tr>\n");

        //Render day labels
        for (int i = 0; i < 7; i++) {
            sbf.append("      <td class=\"day-head\">" + days[i] + "</td>\n");
        }

        sbf.append("    </tr>\n" +
                "    <tr>\n");

        //Fill the first week in the month with the appropiate day offset
        for (int i = 0; i < firstWeekDay; i++) {
            sbf.append("      <td class=\"empty\"> </td>\n");
        }

        int weekDay = firstWeekDay;
        for (int i = 1; i <= daysInMonth; i++) {
            weekDay %= 7;
            if (weekDay == 0) {
                sbf.append("    </tr>\n" +
                        "    <tr>\n");
            }

            Iterator<EventElement> evsNow = EventElement.listEventElementsByDate(user, new Date(year, month, i), wpage, wpage.getWebSite());
            String eventTitles = "";

            while (evsNow.hasNext()) {
                EventElement eve = evsNow.next();
                eventTitles = eventTitles + "* " + eve.getTitle().trim() + "&#10;";
            }

            //Today?
            if (day == i - 1) {
                //Are there events today?
                if (!eventTitles.equals("")) {
                    String viewUrl = paramRequest.getResourceBase().getAttribute("eventsPath", "#");
                    viewUrl = viewUrl + "?y=" + String.valueOf(year) + "&m=" +String.valueOf(month) + "&d=" + String.valueOf(i);

                    sbf.append("      <td class=\"dated\">\n" +
                            "        <div class=\"daylabel\"><a href=\"" + viewUrl + "\">" + i + "</a></div>\n" +
                            "      </td>\n");
                }  else {
                    //There aren't events today
                    sbf.append("      <td class=\"day\">\n" +
                            "<div class=\"daylabel\">" + i + "</div>\n" +
                            "      </td>\n");
                }
            } else {
                //Not today
                evsNow = EventElement.listEventElementsByDate(user, new Date(year, month, i), wpage, wpage.getWebSite());
                if (!eventTitles.equals("")) {
                    String viewUrl = paramRequest.getResourceBase().getAttribute("eventsPath", "#");
                    viewUrl = viewUrl + "?y=" + String.valueOf(year) + "&m=" +String.valueOf(month) + "&d=" + String.valueOf(i);

                    sbf.append("      <td class=\"dated\">\n" +
                            "        <div class=\"daylabel\"><a href=\"" + viewUrl + "\">" + i + "</a></div>\n" +
                            "      </td>\n");
                } else {
                    sbf.append("      <td class=\"day\" >\n" +
                            "        <div class=\"daylabel\">" + i + "</div>\n" +
                            "      </td>\n");
                }
            }
            weekDay++;
        }
        for(int i = 0; i < (7-weekDay); i++) {
            sbf.append("      <td class=\"empty\" >\n" +
                            "      </td>\n");
        }
        sbf.append("    </tr>\n" +
                "  </table>\n" +
                "</div>\n");

        return sbf.toString();
    }
%>