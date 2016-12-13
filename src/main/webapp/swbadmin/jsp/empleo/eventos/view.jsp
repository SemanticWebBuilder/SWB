<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.*"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.util.SWBPriorityComparator"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>

<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.ResourceSubType"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.Resourceable"%>
<%@page import="com.infotec.swb.resources.eventcalendar.*"%>
<%!

public static String changeCharacters(String data)
    {
        if (data == null || data.trim().equals(""))
        {
            return data;
        }
        String changeCharacters = data.toLowerCase().trim();
        if (changeCharacters.indexOf("[") != -1)
        {
            changeCharacters = changeCharacters.replace('[', ' ');
        }
        if (changeCharacters.indexOf("]") != -1)
        {
            changeCharacters = changeCharacters.replace(']', ' ');
        }
        if (changeCharacters.indexOf("/") != -1)
        {
            changeCharacters = changeCharacters.replace('/', ' ');
        }
        if (changeCharacters.indexOf(";") != -1)
        {
            changeCharacters = changeCharacters.replace(';', ' ');
        }
        if (changeCharacters.indexOf(":") != -1)
        {
            changeCharacters = changeCharacters.replace(':', ' ');
        }
        if (changeCharacters.indexOf("-") != -1)
        {
            changeCharacters = changeCharacters.replace('-', ' ');
        }
        if (changeCharacters.indexOf(",") != -1)
        {
            changeCharacters = changeCharacters.replace(',', ' ');
        }
        changeCharacters = changeCharacters.replace('á', 'a');
        changeCharacters = changeCharacters.replace('é', 'e');
        changeCharacters = changeCharacters.replace('í', 'i');
        changeCharacters = changeCharacters.replace('ó', 'o');
        changeCharacters = changeCharacters.replace('ú', 'u');
        changeCharacters = changeCharacters.replace('à', 'a');
        changeCharacters = changeCharacters.replace('è', 'e');
        changeCharacters = changeCharacters.replace('ì', 'i');
        changeCharacters = changeCharacters.replace('ò', 'o');
        changeCharacters = changeCharacters.replace('ù', 'u');
        changeCharacters = changeCharacters.replace('ü', 'u');

        StringBuilder sb = new StringBuilder();
        boolean addSpace = true;
        for (char schar : changeCharacters.toCharArray())
        {
            if (schar == ' ')
            {
                if (addSpace)
                {
                    sb.append(schar);
                    addSpace = false;
                }
            }
            else
            {
                sb.append(schar);
                addSpace = true;
            }

        }
        return sb.toString().trim();
    }

    public String getTitleURL(String title)
    {
        title = changeCharacters(title);

        StringBuilder sb = new StringBuilder();

        for (char s : title.toCharArray())
        {
            if (s == ' ')
            {
                sb.append('-');
            }
            else if (Character.isLetterOrDigit(s))
            {
                sb.append(s);
            }
            else
            {
                sb.append('-');
            }
        }
        return sb.toString();
    }
    public Set<Integer> getDays(Set<Event> eventos, int year, int month)
    {

        HashSet<Integer> getYears = new HashSet<Integer>();
        for (Event event : eventos)
        {
            Date date = event.getStart();
            if (date != null && date.getYear() == year && date.getMonth() == month && event.isActive())
            {
                getYears.add(date.getDate());
            }
        }
        return getYears;

    }

    public Set<Integer> getMonths(List<com.infotec.swb.resources.eventcalendar.Event> eventos, int year)
    {

        HashSet<Integer> getYears = new HashSet<Integer>();
        for (Event event : eventos)
        {
            //Date date = event.getStart();
            //if (date != null && date.getYear() == year && event.isActive())
            if( event.getStart()!=null && event.getStart().getYear()==year && event.isActive())
            {
                getYears.add(event.getStart().getMonth());
            }
        }
        return getYears;

    }

    public Set<Event> getEvents(Set<Event> eventos, int year, int month, int day)
    {

        HashSet<Event> getYears = new HashSet<Event>();
        for (Event event : eventos)
        {
            //Date date = event.getExpiration();
            //if (date != null && date.getYear() == year && date.getDate() == day && date.getMonth() == month && event.isActive())
            if( event.getStart()!=null && event.getStart().getYear()==year && (event.getStart().getMonth()==month||event.getEnd().getMonth()==month) && event.getStart().getDate()==day && event.isActive())
            {
                getYears.add(event);
            }
        }
        return getYears;

    }

    public Set<Event> getEvents(List<Event> eventos, int year, int month)
    {

        HashSet<Event> getYears = new HashSet<Event>();
        for (Event event : eventos)
        {
            //Date date = event.getExpiration();
            //if( date!=null && date.getYear()==year && date.getMonth()==month && event.isActive())
            if( event.isActive() && (event.getStart()!=null && event.getStart().getYear()==year && event.getStart().getMonth()==month || event.getEnd()!=null && event.getEnd().getYear()==year && event.getEnd().getMonth()==month) )
            {
                getYears.add(event);
            }
        }
        return getYears;

    }

    enum MonthOfYear
    {

        enero("Enero"),
        febrero("Febrero"),
        marzo("Marzo"),
        abril("Abril"),
        mayo("Mayo"),
        junio("Junio"),
        julio("Julio"),
        agosto("Agosto"),
        septiembre("Septiembre"),
        octubre("Octubre"),
        noviembre("Noviembre"),
        diciembre("Diciembre");
        private String description;

        MonthOfYear(String description)
        {
            this.description = description;
        }

        public String getDescription()
        {
            return this.description;
        }

        public MonthOfYear previus()
        {
            switch (this)
            {
                case enero:
                    return enero;
                case febrero:
                    return enero;
                case marzo:
                    return febrero;
                case abril:
                    return marzo;
                case mayo:
                    return abril;
                case junio:
                    return mayo;
                case julio:
                    return junio;
                case agosto:
                    return julio;
                case septiembre:
                    return agosto;
                case octubre:
                    return septiembre;
                case noviembre:
                    return octubre;
                case diciembre:
                    return noviembre;
                default:
                    return null;
            }
        }

        public MonthOfYear next()
        {
            switch (this)
            {
                case enero:
                    return febrero;
                case febrero:
                    return marzo;
                case marzo:
                    return abril;
                case abril:
                    return mayo;
                case mayo:
                    return junio;
                case junio:
                    return julio;
                case julio:
                    return agosto;
                case agosto:
                    return septiembre;
                case septiembre:
                    return octubre;
                case octubre:
                    return noviembre;
                case noviembre:
                    return diciembre;
                case diciembre:
                    return diciembre;
                default:
                    return null;
            }
        }

        public boolean hasNext()
        {
            switch (this)
            {
                case diciembre:
                    return false;
                default:
                    return true;
            }
        }

        public static MonthOfYear valueOf(int value) throws IllegalArgumentException
        {
            switch (value)
            {
                case 0:
                    return enero;
                case 1:
                    return febrero;
                case 2:
                    return marzo;
                case 3:
                    return abril;
                case 4:
                    return mayo;
                case 5:
                    return junio;
                case 6:
                    return julio;
                case 7:
                    return agosto;
                case 8:
                    return septiembre;
                case 9:
                    return octubre;
                case 10:
                    return noviembre;
                case 11:
                    return diciembre;
                default:
                    return null;
            }
        }
    }
%><%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    Resource base = paramRequest.getResourceBase();
    int currentYear = Calendar.getInstance().getTime().getYear();
    Iterator<Event> itevents = Event.ClassMgr.listEvents(paramRequest.getWebPage().getWebSite());
    List<Event> events = SWBUtils.Collections.copyIterator(itevents);
    List<Event> temp = new ArrayList<Event>();
    for (Event event : events)
    {
        //if(event.getExpiration() != null && event.isValid() && currentYear == event.getExpiration().getYear())
        if( event.isValid() && event.getStart()!=null && event.getStart().getYear()==currentYear )
            temp.add(event);

    }
    events.clear();
    events.addAll(temp);
    Collections.sort(events, new Event.EventSortByStartDate());

    Locale locale = new Locale("es", "MX");
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM", locale);
    GregorianCalendar gc = new GregorianCalendar(locale);
    boolean hasAhead = false, hasBehind = false;

    MonthOfYear moy;
    if (request.getParameter("m") == null)
    {
        try
        {
            moy = MonthOfYear.valueOf(sdf.format(gc.getTime()).toLowerCase());
        }
        catch (IllegalArgumentException e)
        {
            //log.debug(e);
            moy = MonthOfYear.valueOf(gc.getTime().getMonth());
        }
    }
    else
    {
        try
        {
            moy = MonthOfYear.valueOf(Integer.parseInt(request.getParameter("m")));
            if (moy.ordinal() < gc.get(Calendar.MONTH))
                hasBehind = false;
            else
                hasBehind = true;
        }
        catch (NumberFormatException e)
        {
            //log.debug(e);
            moy = MonthOfYear.valueOf(gc.getTime().getMonth());
        }
    }
    int m = moy.ordinal();

    gc = new GregorianCalendar(gc.get(Calendar.YEAR), m, 1, 0, 0, 0);
    Date di = gc.getTime();



    Set<Event> allEventsOnMonth = getEvents(events, currentYear, moy.ordinal());
    Set<Event> eventsOnMonth = new HashSet<Event>();
    for (Event event : allEventsOnMonth)
    {
        if (event.getStart()!=null && event.getStart().after(di))
        {
            eventsOnMonth.add(event);
        }
    }

    if (eventsOnMonth.isEmpty())
    {
        int nextmonth = moy.next().ordinal();
        for (int imonth = nextmonth; imonth <= 11; imonth++)
        {
            Set<Event> tempEvents = getEvents(events, currentYear, imonth);
            if (!tempEvents.isEmpty())
            {
                moy = MonthOfYear.valueOf(imonth);
                eventsOnMonth.clear();
                eventsOnMonth.addAll(tempEvents);
                break;
            }
        }
    }
    out.println("<script type=\"text/javascript\">");
    out.println("<!--");
    out.println(" dojo.require('dijit.dijit');");
    out.println("-->");
    out.println("</script>");
    SWBResourceURL url = paramRequest.getRenderUrl().setCallMethod(paramRequest.Call_DIRECT).setMode("roll");
    Set<Integer> months = getMonths(events, currentYear);
    out.println("<div id=\"calendario_eventos\">");
    if (months.size() > 0)
    {


        int nextmonth = moy.next().ordinal();
        int previousmonth = moy.previus().ordinal();

        for (int imonth = nextmonth; imonth <= 11; imonth++)
        {
            Set<Event> tempEvents = getEvents(events, currentYear, imonth);
            if (!tempEvents.isEmpty())
            {
                nextmonth = imonth;
                hasAhead = true;
                break;
            }
        }



        for (int imonth = previousmonth; imonth >= 0; imonth--)
        {
            Set<Event> tempEvents = getEvents(events, currentYear, imonth);
            if (!tempEvents.isEmpty())
            {
                previousmonth = imonth;
                hasBehind = true;
                break;
            }
        }

        if (hasAhead && nextmonth == 11 && moy == MonthOfYear.diciembre)
        {
            hasAhead = false;
        }
        if (hasBehind && previousmonth == (Calendar.getInstance().getTime().getMonth() - 1))
        {
            hasBehind = false;
        }
        if (hasBehind && Calendar.getInstance().getTime().getMonth() == 0)
        {
            hasBehind = false;
        }

        sdf = new SimpleDateFormat("dd 'de' '<span class=\"cap\">'MMMM'</span>' 'de' yyyy", locale);
        SimpleDateFormat md = new SimpleDateFormat("'<span class=\"cap\">'MMM'</span>' dd", locale);
        SimpleDateFormat dd = new SimpleDateFormat("dd", locale);
        out.println(" <div id=\"mes\">");
        if (hasBehind)
        {
            url.setParameter("m", Integer.toString(previousmonth));
            out.println(" <a id=\"mes_anterior\" href=\"javascript:postHtml('" + url + "','calendario_eventos')\" >mes anterior</a>");
        }
        out.println("  <h3>"+moy.getDescription()+" "+Calendar.getInstance().get(Calendar.YEAR)+"</h3>");
        if (hasAhead)
        {
            url.setParameter("m", Integer.toString(nextmonth));
            out.println(" <a id=\"mes_siguiente\" href=\"javascript:postHtml('" + url + "','calendario_eventos')\" >mes siguiente</a>");
        }
        out.println(" </div>"); // mes

        events.clear();
        events.addAll(eventsOnMonth);
        Collections.sort(events, new Event.EventSortByStartDate());
        for (Event event : events)
        {
            out.println("<div>");
            out.println("<div class=\"range\">");
            if(event.getEnd()==null) {
                out.println("<span class=\"dia_calendario\">"+md.format(event.getStart())+"</span>");
            }else if(event.getEnd()!=null && event.getStart().getMonth()==event.getEnd().getMonth()) {
                out.println("<span class=\"dia_calendario\">"+md.format(event.getStart())+"</span> <span class=\"art\">al</span> <span class=\"dia_calendario\">"+dd.format(event.getEnd())+"</span>");
            }else if(event.getEnd()!=null && event.getStart().getMonth()!=event.getEnd().getMonth()){
                out.println("<span class=\"dia_calendario\">"+md.format(event.getStart())+"</span> <span class=\"art\">a</span> <span class=\"dia_calendario\">"+md.format(event.getEnd())+"</span>");
            }
            String titleURL=getTitleURL(event.getDisplayTitle(paramRequest.getUser().getLanguage()));
            out.println("</div>");
            out.println("<p><a href=\"" + event.getUrl()+"/"+titleURL + "\">" + event.getTitle() + "</a></p>");
            out.println("<p>"+sdf.format(event.getStart())+"</p>");
            out.println("<p>"+(event.getSchedule()==null?"":event.getSchedule())+"</p>");
            out.println(" </div>");
        }
        out.println(" </div>");
    }

    Iterator<Resourceable> pages = paramRequest.getResourceBase().listResourceables();
    String urltoViewAll = null;
    if (pages.hasNext())
    {
        Resourceable resourceable = pages.next();
        if (resourceable instanceof WebPage)
        {
            WebPage opage = (WebPage) resourceable;
            if (opage.isValid())
            {
                urltoViewAll = opage.getUrl();
            }
        }
    }
    if (urltoViewAll != null)
    {
        //url.setCallMethod(paramRequest.Call_CONTENT).setMode("vall");
        out.println("<div class=\"bottom_calendario\">");
        //out.println(" <a style=\"float: right; margin: 10px 20px 0pt 0pt;\" name=\"a_"+base.getId()+"\" href=\""+url+"#a_"+base.getId()+"\" class=\"links\">ver todos los eventos</a>");
        out.println(" <a style=\"float: right; margin: 10px 20px 0pt 0pt;\" name=\"a_" + base.getId() + "\" href=\"" + urltoViewAll + "\" class=\"links\">ver todos los eventos</a>");
        out.println("</div>");
    }
%>
