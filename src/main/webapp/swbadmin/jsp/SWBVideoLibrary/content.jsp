<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.videolibrary.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.User"%>
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
<%!
    static String[] meses =
    {
        "Enero", "Febrero", "Marzo", "Abril", "Mayo",
        "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    };
    static String[] months =
    {
        "January", "February", "March", "April", "May",
        "June", "July", "August", "September", "October", "November", "December"
    };

    private String getMonth(int month,User user)
    {
        String getMonth=meses[month];        
        return getMonth;
    }

    private static String mensaje = "Videos de ";
    private static String mesage = "Videos of ";
    private static String ultmsg = "Videos del mes";
    private static String lastmsg = "Previous videos";
%>
<%
    String usrlanguage = paramRequest.getUser().getLanguage();
    Locale locale=new Locale(usrlanguage);
    Calendar calendar = Calendar.getInstance(locale);

    int currentMonth=calendar.get(Calendar.MONTH);

    DateFormat sdf = DateFormat.getDateInstance(DateFormat.MEDIUM, new Locale(usrlanguage));
    int limit = 15;

    List<VideoContent> contents=(List<VideoContent>)request.getAttribute("list");
    Collections.sort(contents, new VideoContentComparator());
    if(contents!=null && contents.size()>0)
    {
       
        // muestra los 15 primeros videos
        int i=0;
        for(VideoContent content : contents)
        {
            i++;
            SWBResourceURL url=paramRequest.getRenderUrl();
            url.setMode(paramRequest.Mode_VIEW);
            url.setParameter("uri",content.getResourceBase().getSemanticObject().getURI());
            String title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle(usrlanguage));
            if(title!=null && title.trim().equals(""))
            {
                title=SWBUtils.TEXT.encodeExtendedCharacters(content.getResourceBase().getTitle());
            }
            String titleImage=title.replace('"', '\'');
            String date="";
            if(content.getPublishDate()!=null)
            {
                date=sdf.format(content.getPublishDate());
            }
            String preview=content.getPreview();            
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
                <%
                    if(preview!=null)
                    {
                        %>
                        <div class="thumbVideo">
                            <img alt="<%=titleImage%>" width="120" height="120" src="<%=preview%>" />
                        </div>
                        <%
                    }
                %>
        
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
            if(i>=limit)
            {
                break;
            }
        }



        String[] years=SWBVideoLibrary.getYears(contents);
        if(years!=null)
        {
            for(String year : years)
            {
                int iyear=Integer.parseInt(year);
                // muestra liga para noticias por mes
                for(int month=11;month>=0;month--)
                {
                    if(SWBVideoLibrary.hasVideo(contents, month,iyear))
                    {

                        String titleMonth=" "+getMonth(month,paramRequest.getUser())+" "+iyear;
                        SWBResourceURL url=paramRequest.getRenderUrl();
                        url.setMode("month");
                        url.setParameter("month", String.valueOf(month));
                        url.setParameter("year", year);
                        String currentyear=String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
                        String urlcontent=url.toString().replace("&", "&amp;");
                        if(currentMonth==month && currentyear.equals(year))
                        {
                            %>
                            <p><a href="<%=urlcontent%>"><%=ultmsg%></a></p>
                            <%
                        }
                        else
                        {
                            %>
                            <p><a href="<%=urlcontent%>"><%=mensaje%><%=titleMonth%></a></p>
                            <%
                        }

                    }
                }
            }
         }       
        
    }
    else
        {
        %>
        <div class="entradaVideos">
        <p>No hay videos disponibles</p>
        </div>
        <%
        }
%>


