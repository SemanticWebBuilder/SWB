<%@page contentType="text/html"%>
<%@page import="java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>

<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    User user = paramRequest.getUser();
    WebPage wpage = paramRequest.getWebPage();
    Member member = Member.getMember(user, wpage);
    String act = "calendar";
    if (request.getParameter("act") != null) act = request.getParameter("act");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    String year = request.getParameter("y");
    String month = request.getParameter("m");
    String day = request.getParameter("d");

    //Create calendar for today
    Calendar currCal = new GregorianCalendar();

    //If specific date required, update calendar
    if(day != null && month != null && year != null) {
        currCal = new GregorianCalendar();
        currCal.set(Calendar.YEAR, Integer.valueOf(year));
        currCal.set(Calendar.MONTH, Integer.valueOf(month));
        currCal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(day));
    }

    String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
    String [] months = {"Enero", "Febrero", "Marzo", "Abril",
                            "Mayo", "Junio", "Julio", "Agosto",
                            "Septiembre", "Octubre", "Noviembre", "Diciembre"};
    String [] days = {"D", "L", "M", "M", "J", "V", "S"};

    //Get current day, month and year as a number
    int ilyear = currCal.get(Calendar.YEAR);
    int ilmonth = currCal.get(Calendar.MONTH);
    int ilday = currCal.get(Calendar.DAY_OF_MONTH);

    //Create calendar for start of month
    Calendar startOfMonth = new GregorianCalendar();

    startOfMonth.setTime(currCal.getTime());
    startOfMonth.set(Calendar.DAY_OF_MONTH, 1);

    //Create calendar for end of month
    Calendar endOfMonth = new GregorianCalendar();
    endOfMonth.setTime(currCal.getTime());
    endOfMonth.set(Calendar.DAY_OF_MONTH, currCal.getActualMaximum(Calendar.DAY_OF_MONTH));

    //Find out when this mont starts and ends
    int offset = startOfMonth.get(startOfMonth.DAY_OF_WEEK) - startOfMonth.SUNDAY;
    int firstWeekDay = offset;
    int daysInMonth = currCal.getActualMaximum(Calendar.DAY_OF_MONTH);

    if (act.equals("calendar") && paramRequest.getCallMethod() != paramRequest.Call_CONTENT) {
        Set<Integer> reserved = new TreeSet<Integer>();

        //Get all events
        Iterator<EventElement> itev = EventElement.ClassMgr.listEventElements();
        while(itev.hasNext()) {
            EventElement ee = itev.next();

            boolean isNow = false;
            try
                    {
            if(ee!=null && ee.getStartDate()!=null && ee.getEndDate()!=null)
                {
            //Get event's start and end days
            int sDay = ee.getStartDate().getDate();
            int eDay = ee.getEndDate().getDate();

            //If member can view the event
            if(ee.canView(member)) {
                //If the event is active this month
                if(isThisMonth(ee, startOfMonth, endOfMonth)) {
                    isNow = true;

                    //If the event started before this month, the month is reserved from its first day
                    if (ee.getStartDate().before(startOfMonth.getTime()) && ee.getEndDate().after(startOfMonth.getTime())) {
                        sDay = 1;
                    }

                    //If the event ends after this month, the month is reserved to its last day
                    if (ee.getEndDate().after(endOfMonth.getTime())) {
                        eDay = (int)daysInMonth;
                    }
                }
            }


            //Add reserved days to the set
            for (int i = sDay; i <= eDay; i++) {
                if (isNow) {
                    reserved.add(i);
                }
            }
}
}


            catch(Exception e){}
        }

        //Build URL for next month
        SWBResourceURL nm = paramRequest.getRenderUrl();
        nm.setParameter("d", "1");
        if (ilmonth == 11) {
            nm.setParameter("m", "0");
            nm.setParameter("y", String.valueOf(ilyear + 1));
        } else {
            nm.setParameter("m", String.valueOf(ilmonth + 1));
            nm.setParameter("y", String.valueOf(ilyear));
        }

        //Build URL for previous month
        SWBResourceURL pm = paramRequest.getRenderUrl();
        pm.setParameter("d", "1");
        if (ilmonth == 0) {
            pm.setParameter("m", "11");
            pm.setParameter("y", String.valueOf(ilyear - 1));
        } else {
            pm.setParameter("m", String.valueOf(ilmonth - 1));
            pm.setParameter("y", String.valueOf(ilyear));
        }

%>
<h2>Eventos del mes</h2>
<div id ="calendario" style="margin:10px; height:220px;">
    <h2>
        <a href="<%=pm.toString(true)+"#anchorDays"%>">&lt;</a>&nbsp;<%=months[ilmonth]%>&nbsp;&nbsp;<%=ilyear%>&nbsp;<a href="<%=nm.toString(true)+"#anchorDays"%>">&gt;</a>
    </h2>
    <ul id="anchorDays" class="dias semana">
        <%
        for(int i = 0; i < 7; i++) {
        %><li> <%=days[i]%></li><%
        }
        %>
    </ul>
    <ul class="dias">
        <%for(int i = 0; i < firstWeekDay; i++) {
        %><li>&nbsp;</li><%        }

        int weekDay = firstWeekDay;
        for (int i = 1; i <= daysInMonth; i++)
        {
            if (reserved.contains(i))
            {
                String dayUrl = paramRequest.getWebPage().getWebSite().getWebPage("Eventos_del_dia").getUrl().toString();
                dayUrl += "?act=daily&amp;y=" + ilyear + "&amp;m=" + ilmonth + "&amp;d=" + i;
        %><li><a href="<%=dayUrl%>"><%=i%></a></li><%
            }
            else
            {
        %><li><%=i%></li><%
            }
        }

        for (int i = 0; i < (7 - weekDay); i++)
        {
        %><li>&nbsp;</li><%        }
        %>
    </ul>
</div>

<div class="clear">&nbsp;</div>
<%}
    else if (act.equals("daily"))
    {
        java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");
        ArrayList<EventElement> events = new ArrayList<EventElement>();

        //Get all events
        Iterator<EventElement> itev = EventElement.ClassMgr.listEventElements();
        while (itev.hasNext())
        {
            EventElement ee = itev.next();

            //Get event's start and end dates
            Calendar sD = new GregorianCalendar();
            Calendar eD = new GregorianCalendar();
            sD.setTime(ee.getStartDate());
            eD.setTime(ee.getEndDate());

            //If member can view event
            if (ee.canView(member))
            {
                //Does the event start or end this day?
                if (same(sD, currCal) || same(eD, currCal))
                {
                    events.add(ee);
                    //Did event start before today and ends after today?
                }
                else if (sD.before(currCal) && eD.after(currCal))
                {
                    events.add(ee);
                }
            }
        }

        int elementos = events.size();
        int paginas = elementos / ELEMENETS_BY_PAGE;
        if (elementos % ELEMENETS_BY_PAGE != 0)
        {
            paginas++;
        }
        int inicio = 0;
        int fin = ELEMENETS_BY_PAGE;
        int ipage = 1;
        if (request.getParameter("ipage") != null)
        {
            try
            {
                ipage = Integer.parseInt(request.getParameter("ipage"));
                inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
                fin = (ipage * ELEMENETS_BY_PAGE);
            }
            catch (NumberFormatException nfe)
            {
                ipage = 1;
            }
        }
        if (ipage < 1 || ipage > paginas)
        {
            ipage = 1;
        }
        if (inicio < 0)
        {
            inicio = 0;
        }
        if (fin < 0)
        {
            fin = ELEMENETS_BY_PAGE;
        }
        if (fin > elementos)
        {
            fin = elementos;
        }
        if (inicio > fin)
        {
            inicio = 0;
            fin = ELEMENETS_BY_PAGE;
        }
        if (fin - inicio > ELEMENETS_BY_PAGE)
        {
            inicio = 0;
            fin = ELEMENETS_BY_PAGE;
        }
        inicio++;

        if (events.size() > 0)
        {
%>
<div class="columnaIzquierda">
    <%
            if (paginas > 1)
            {
    %><div class="paginacion"><%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?act=daily&amp;y=" + ilyear + "&amp;m=" +
                            ilmonth + "&d=" + ilday + "&ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?act=daily&amp;y=" + ilyear + "&amp;m=" +
                            ilmonth + "&d=" + ilday + "&ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %><a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a><%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %><a href="<%=wpage.getUrl()%>?act=daily&amp;y=<%=ilyear%>&amp;m=<%=ilmonth%>&d=<%=ilday%>&amp;ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %><strong><%                    }%>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %></strong><%                    }%>
        </a>
        <%
                }

                if (ipage != paginas)
                {
        %><a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a><%
                }
            %></div><%
            }%>
    <h1>Eventos del <%=dateFormat.format(currCal.getTime())%></h1>
    <%
            int iElement = 0;
            for (EventElement ev : events)
            {
                if (ev.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        String fechaEvento = "Sin determinar";
                        try
                        {
                            fechaEvento = dateFormat.format(ev.getStartDate());
                        }
                        catch (Exception e)
                        {
                        }

                        String hfechaEvento = "Sin determinar";
                        try
                        {
                            hfechaEvento = timeFormat.format(ev.getStartTime());
                        }
                        catch (Exception e)
                        {
                        }

                        String rank = df.format(ev.getRank());
                        String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/EventResource/noevent.jpg";
                        String path = ev.getWorkPath();
                        if (ev.getEventThumbnail() != null)
                        {
                            int pos = ev.getEventThumbnail().lastIndexOf("/");
                            if (pos != -1)
                            {
                                String sphoto = ev.getEventThumbnail().substring(pos + 1);
                                ev.setEventThumbnail(sphoto);
                            }
                            pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + ev.getEventThumbnail();
                        }

                        String postAuthor = "Usuario dado de baja";
                        if (ev.getCreator() != null)
                        {
                            postAuthor = ev.getCreator().getFirstName();
                        }


                        String viewUrl = ev.getURL();
    %>
    <div class="noticia">
        <img src="<%=pathPhoto%>" alt="<%= ev.getTitle()%>"/>
        <div class="noticiaTexto">
            <h2><%=ev.getTitle()%></h2>
            <p>Fecha del evento: <%=fechaEvento%> a las <%=hfechaEvento%><br/>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(ev.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(ev.getCreated(), user.getLanguage())%></p>
            <p>
                <%=ev.getDescription()%> | <a href="<%=viewUrl%>">Ver m&aacute;s</a>
            </p>
            <p class="stats">
                Puntuación: <%=rank%><br/>
                <%=ev.getViews()%> vistas
            </p>
        </div>
    </div>
    <%
                    }
                }
            }
    %>
    <!-- paginacion -->
    <%
            if (paginas > 1)
            {
    %><div class="paginacion"><%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?act=daily&amp;y=" + ilyear + "&amp;m=" +
                            ilmonth + "&amp;d=" + ilday + "&amp;ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?act=daily&amp;y=" + ilyear + "&amp;m=" +
                            ilmonth + "&amp;d=" + ilday + "&amp;ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %><a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a><%
                }

                for (int i = 1; i <= paginas; i++)
                {
            %><a href="<%=wpage.getUrl()%>?act=daily&amp;y=<%=ilyear%>&amp;m=<%=ilmonth%>&amp;d=<%=ilday%>&amp;ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %><strong><%                    }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %></strong><%                    }
        %></a><%
                }
                if (ipage != paginas)
                {
        %><a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a><%
                }
            %></div><%
            }
    %>
    <!-- fin paginacion -->
</div>
<%
        }
        else
        {
%><h2>No existen eventos para este d&iacute;a</h2><%        }
    }
%>

<%!
private boolean same(Calendar d1, Calendar d2) {
    boolean ret = false;

    if (d1.get(Calendar.YEAR) == d2.get(Calendar.YEAR) &&
            d1.get(Calendar.MONTH) == d2.get(Calendar.MONTH) &&
            d1.get(Calendar.DAY_OF_MONTH) == d2.get(Calendar.DAY_OF_MONTH)) {
        ret = true;
    }

    return ret;
}
%>

<%!
private  boolean isThisMonth(EventElement event, Calendar startOfM, Calendar endOfM) {
    boolean ret = false;

    Calendar sD = new GregorianCalendar();
    Calendar eD = new GregorianCalendar();
    sD.setTime(event.getStartDate());
    eD.setTime(event.getEndDate());


    //El evento inició algun día de este mes?
    if ((same(sD, startOfM) || sD.after(startOfM)) &&
            (same(sD, endOfM) || sD.before(endOfM))) {
        ret = true;
    }

    //El evento inició algun día de este mes?
    if ((same(eD, startOfM) || eD.after(startOfM)) &&
            (same(eD, endOfM) || eD.before(endOfM))) {
        ret = true;
    }

    //El evento inició antes del mes y termina despues del mes?
    if (sD.before(startOfM) && eD.after(endOfM)) {
        ret = true;
    }

    return ret;
}
%>