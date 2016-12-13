<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.videolibrary.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.*"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
    class VideoContentComparator implements Comparator<VideoContent>
    {
        public int compare(VideoContent o1,VideoContent o2)
        {
            try
            {
                return o1.getResourceBase().getIndex()>=o2.getResourceBase().getIndex()?1:-1;
            }
            catch(Exception e)
            {
            }
            return 0;
        }
    }
%>
<%
    String usrlanguage = paramRequest.getUser().getLanguage();    
    DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));

    List<VideoContent> contents=(List<VideoContent>)request.getAttribute("list");
    Collections.sort(contents, new VideoContentComparator());
    if(contents!=null && contents.size()>0)
    {        
        for(VideoContent content : contents)
        {
            if(content.getPublishDate()!=null)
            {
                int month=-1;
                if(request.getParameter("month")!=null)
                {
                    try
                    {
                        month=Integer.parseInt(request.getParameter("month"));
                    }
                    catch(NumberFormatException e)
                    {
                        e.printStackTrace();
                    }
                }
                Calendar cal=Calendar.getInstance();
                cal.setTime(content.getPublishDate());
                int year=Calendar.getInstance().get(Calendar.YEAR);
                if(request.getParameter("year")!=null)
                {
                    try
                    {
                        year=Integer.parseInt(request.getParameter("year"));
                    }
                    catch(NumberFormatException e)
                    {
                        e.printStackTrace();
                    }
                }
                if(!(month==cal.get(Calendar.MONTH) && year==cal.get(Calendar.YEAR)))
                {
                    continue;
                }
            }
            SWBResourceURL url=paramRequest.getRenderUrl();
            url.setParameter("uri",content.getResourceBase().getSemanticObject().getURI());
            url.setMode(paramRequest.Mode_VIEW);
            url.setCallMethod(paramRequest.Call_CONTENT);
            String title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle(usrlanguage));             
            if(title!=null && title.trim().equals(""))
            {
                title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle());
            }
            String titleImage=title.replace('"', '\'');
            String date=sdf.format(content.getPublishDate());
            String preview=content.getCode();
            String source=content.getSource();
            String ago="";
            if(date!=null && !date.trim().equals(""))
            {
                if (content.getPublishTime() != null)
                {
                    Date time = content.getPublishTime();
                    Calendar cal = Calendar.getInstance();
                    Calendar cal2 = Calendar.getInstance();
                    cal2.setTime(time);
                    cal.setTime(content.getPublishDate());
                    cal.set(Calendar.HOUR_OF_DAY, cal2.get(Calendar.HOUR_OF_DAY));
                    cal.set(Calendar.MINUTE, cal2.get(Calendar.MINUTE));
                    cal.set(Calendar.SECOND, cal2.get(Calendar.SECOND));
                    cal.set(Calendar.MILLISECOND, cal2.get(Calendar.MILLISECOND));
                    ago = SWBUtils.TEXT.getTimeAgo(cal.getTime(), usrlanguage);
                }
                else
                {
                    ago = SWBUtils.TEXT.getTimeAgo(content.getPublishDate(), usrlanguage);
                }
                
            }
            %>
            <div class="entradaVideos">
        <div class="thumbVideo">
          <%--<img alt="<%=titleImage%>" src="<%=preview%>" /> --%>
          <%=preview%>
        </div>
        <div class="infoVideo">
            <h3><%=title%></h3>
            <p class="fechaVideo">
                <%
                    if(date!=null && !date.trim().equals(""))
                    {
                        %>
                        <%=date%> - <%=ago%>
                        <%
                    }
                %>

            </p>
            <%
                    if(source!=null)
                    {
                        if(content.getVideoWebPage()==null)
                        {
                            %>
                            <p>Fuente: <%=source%></p>
                            <%
                        }
                        else
                        {
                            String urlsource=content.getVideoWebPage();
                            urlsource=urlsource.replace("&", "&amp;");
                            %>
                            <p>Fuente: <a href="<%=urlsource%>"><%=source%></a></p>
                            <%
                        }
                    }
                %>
            <p class="vermas"><a href="<%=url%>">Ver Más</a></p>
        </div>
        <div class="clear">&nbsp;</div>
        </div>
            <%
        }
        SWBResourceURL urlall=paramRequest.getRenderUrl();
        urlall.setMode(urlall.Mode_VIEW);
        urlall.setCallMethod(urlall.Call_CONTENT);
        String viewAll="[Ver todos los videos]";
        if(paramRequest.getUser().getLanguage()!=null && !paramRequest.getUser().getLanguage().equalsIgnoreCase("en"))
        {
            viewAll="[View all videos]";
        }
        %>
        <p><a href="<%=urlall%>"><%=viewAll%></a></p>
        <%
        
    }
%>