<%-- 
    Document   : siteAnalytics
    Created on : 21/10/2013, 05:01:04 PM
    Author     : carlos.alvarez
--%>

<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="java.io.File"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="org.semanticwb.portal.access.LinkedPageCounter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script type="text/javascript" src="/swbadmin/js/dojo/dojo/dojo.js" djConfig="parseOnLoad: true, isDebug: false, locale: 'es'" ></script>
<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
  <script src="<%=SWBPlatform.getContextPath()%>/swbadmin/jsp/process/utils/html5shiv.js"></script>
  <script src="<%=SWBPlatform.getContextPath()%>/swbadmin/jsp/process/utils/respond.mi.js"></script>
<![endif]-->
<link href="<%=SWBPlatform.getContextPath()%>/swbadmin/css/bootstrap/bootstrap.css" rel="stylesheet"></link>
<link href="<%=SWBPlatform.getContextPath()%>/swbadmin/css/fontawesome/font-awesome.css" rel="stylesheet"></link>
<script type="text/javascript" src="<%=SWBPlatform.getContextPath()%>/swbadmin/js/jquery/jquery.js"></script>
<script src="<%=SWBPlatform.getContextPath()%>/swbadmin/js/d3/d3.js"></script>
<style>
    .swbp-table thead > tr > th, .panel-heading {
        color: black;
        background: -moz-linear-gradient(center top , #eef2fd 0%, #cbddf3 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
        background-image:-webkit-gradient(linear,0 0,0 100%,from(#ff1d1b),color-stop(50%,#cbddf3),to(#b90200));
        background-image:-webkit-linear-gradient(#eef2fd,#cbddf3 100%);
        background-image:-moz-linear-gradient(top,#eef2fd,#cbddf3 100%);
        background-image:linear-gradient(#eef2fd,#cbddf3 100%);
        filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#eef2fd',endColorstr='#cbddf3',GradientType=0);
    }
    .chartToolTip {
        background-color: white;
        border: 2px solid #aaaaaa;
        border-radius: 4px;
        padding: 3px;
        vertical-align: middle;
    }

    .chartToolTip p {
        text-align: center;
        cursor: pointer;
    }
    .stats {
        display: table;
        margin-bottom: 1.9em;
        margin-top: 0.5em;
        padding: 0 0 0 10px;
        width: 100%;
    }
    .stat {
        color: #999999;
        display: table-cell;
        font-size: 11px;
        font-weight: bold;
        vertical-align: top;
        width: 40%;
    }
    .stat-value {
        color: #444444;
        display: block;
        font-size: 30px;
        font-weight: bold;
        letter-spacing: -2px;
        /*margin-bottom: 0.55em;*/
    }
</style>
<script>
     $(document).ready(function () {
    if (jQuery.isFunction(updateCharts)) {
      updateCharts();
    }
    //Manage charts resize
    $(window).resize(function() {
        if (jQuery.isFunction(updateCharts)) {
          updateCharts();
        }
      $(".chartToolTip").css("display","none");
    });
  });
    var color = d3.scale.category10();
    function updateChart(chartContainer, title, data) {
        var width,
                height,
                radius,
                offset = 20;
        var pie = d3.layout.pie()
                .sort(null)
                .value(function(d) {
            return d.value;
        });
        var sum = d3.sum(data, function(d) {
            return d.value;
        });

        height = width = $(chartContainer).parent().width();
        radius = (height - (height * .2)) / 2;

        //replace container content
        $(chartContainer).html("<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%'></svg>");

        //create arcs function
        var arc = d3.svg.arc()
                .outerRadius(radius - 15)
                .innerRadius(radius * .5);

        //create outter arcs function
        var arcOver = d3.svg.arc()
                .outerRadius(radius - 5)
                .innerRadius(radius - 15);

        //Add graph contents
        var svg = d3.select(chartContainer + " svg")
                .attr("width", width)
                .attr("height", height)
                .append("g")
                .attr("transform", "translate(" + width / 2 + "," + (height / 2 + offset) + ")");

        //Outter arcs selector
        var gl = svg.selectAll(".arcOver")
                .data(pie(data))
                .enter().append("g")
                .attr("class", "arcOver")
                .style("visibility", "hidden");

        gl.append("path")
                .attr("d", arcOver)
                .style("fill-opacity", "0.6")
                .style("fill", function(d, i) {
            return color(i);
        });

        //Create tooltips
        var tooltips = svg.select("body")
                .data(pie(data))
                .enter().append("div")
                .attr("class", "chartToolTip")
                .style("display", "none")
                .style("position", "absolute")
                .style("z-index", "10");

        tooltips.append("p")
                .append("span")
                .html(function(d) {
            var pc = ((d.data.value / sum) * 100);
            if (pc % 1 > 0) {
                pc = pc.toFixed(3);
            }
            return "<strong>" + d.data.label + "</strong><br>" + d.data.value + " (" + pc + "%)";
        });

        //Arcs selector
        var g = svg.selectAll(".arc")
                .data(pie(data))
                .enter().append("g")
                .attr("class", "arc")
                .on("mouseover", function(d, i) {
            d3.select(gl[0][i]).style("visibility", "visible");
            d3.select(tooltips[0][i])
                    .style("display", "block");
        })
                .on("mouseout", function(d, i) {
            d3.select(gl[0][i]).style("visibility", "hidden");
            d3.select(tooltips[0][i])
                    .style("display", "none");
            d3.select(gl[0][i]).style("fill", function(d) {
                return color(d.data.label);
            });
        })
                .on("mousemove", function(d, i) {
            d3.select(tooltips[0][i])
                    .style("top", d3.event.pageY - 10 + "px")
                    .style("left", d3.event.pageX + 10 + "px")
        });

        //Create slices
        g.append("path")
                .attr("d", arc)
                .style("stroke", "white")
                .style("stroke-width", "2")
                .style("fill", function(d, i) {
            return color(i);
        });

        svg
                .append("text")
                .text(title)
                .style("text-anchor", "middle")
                .style("fill", "black")
                .style("font-size", "10pt")
                .style("font-weight", "bold")
                .attr("x", "0")
                .attr("y", function(d) {
            return -width / 2;
        });
    }
</script>
<div class="container">
    <%
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
        SWBResourceURL url = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode("doLoad");
        ArrayList list = (ArrayList) request.getAttribute("list");
        String log = request.getAttribute("log") != null ? request.getAttribute("log").toString() : "";
        String p = request.getParameter("p") != null ? request.getParameter("p") : "";
        String nameSelected = session.getAttribute("nameSelected") != null ? session.getAttribute("nameSelected").toString() : "";
        if (!log.equals("")) {
            nameSelected = log.substring((log.lastIndexOf("\\") + 1), log.length());
            session.setAttribute("nameSelected", nameSelected);
        }
        String title = paramRequest.getLocaleLogString("totalView");
        LinkedPageCounter cpage = null;
        if (p.length() > 0) {
            cpage = LinkedPageCounter.getCounter(p);
            title = cpage.getId();
        }
        String rest = request.getParameter("rest");
        if (!log.equals("")) {
            if (!LinkedPageCounter.isLoading()) {
                rest = null;
            }
        }
        String hits = "Hits";
%>
    <div class="panel panel-default">
        <div class="panel-body">
            <span><%=paramRequest.getLocaleString("selectLog")%>:</span>
            <form method="post" class="form-inline" id="formm">
                <div class="form-group">
                    <select name="log" id="log" class="form-control">
                        <%
                            for (int i = 0; i < list.size(); i++) {
                                StringTokenizer values = new StringTokenizer(list.get(i).toString(), "|");
                                String path = values.nextToken();
                                //System.out.println("value: " + path);
                                String name = values.nextToken();
                        %>
                        <option id="<%=name%>" value="<%=path%>" <%if (name.equals(nameSelected)) {%> selected="true" <%}%>><%=name%></option>
                        <%
                            }%>
                    </select>
                </div>
                <button type="submit" class="btn btn-default btn-info" onclick="submitUrls('<%=url%>', this);
        return false;"><%=paramRequest.getLocaleString("load")%></button>
            </form> 
        </div>
    </div>
    <%
        if (!nameSelected.equals("")) {
            int totalHits = LinkedPageCounter.getTotalHits();
            int totalSessions = LinkedPageCounter.getTotalSessions();
            int totalSessionsExist = LinkedPageCounter.getTotalSessionsReused();
            int[] totals = new int[4];
            Iterator<LinkedPageCounter> treeSet = LinkedPageCounter.listPages().iterator();
            while (treeSet.hasNext()) {
                LinkedPageCounter cpag = treeSet.next();
                totals[0] += cpag.getTotalChildCounter();
                totals[1] += (cpag.getCounter() - cpag.getTotalChildCounter());
                totals[2] += cpag.getTotalParentCounter();
                totals[3] += (cpag.getCounter() - cpag.getTotalParentCounter());
            }
    %>
    <div class="panel panel-default">
        <div class="panel-heading">
            <div class="panel-title text-center">
                <strong><%=title + " :: " + nameSelected%></strong>
                <%if (p != null && p.length() > 0) {%>
                <a href="?p=" class="btn btn-default btn-info fa fa-home pull-right"></a>
                <%}%>
            </div>
        </div>
        <div class="panel-body">
            <!-- Graph for pages -->
            <%if (p != null && p.length() > 0) {%>
            <!-- First row  -->
            <div class="row">
                <!-- Permanencia en sitio -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-bookmark"></i> <%=paramRequest.getLocaleString("permanence")%></strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=cpage.getCounter()%></span>
                                    Hits
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=cpage.getTotalChildCounter()%></span>
                                    <%=paramRequest.getLocaleString("continued")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=(cpage.getCounter() - cpage.getTotalChildCounter())%></span>
                                    <%=paramRequest.getLocaleString("dontContinued")%>
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="continuePage"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Comes -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-tags"></i> <%=paramRequest.getLocaleString("reference")%></strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=cpage.getCounter()%></span>
                                    Total
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=cpage.getTotalParentCounter()%></span>
                                    <%=paramRequest.getLocaleString("intern")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=(cpage.getCounter() - cpage.getTotalParentCounter())%></span>
                                    <%=paramRequest.getLocaleString("extern")%>
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="comesPage"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
    data = [{"label": "<%=paramRequest.getLocaleString("continued")%>", "value":<%=cpage.getCounter()%>},
        {"label": "<%=paramRequest.getLocaleString("dontContinued")%>", "value":<%=(cpage.getCounter() - cpage.getTotalChildCounter())%>}
    ];
    updateChart("#continuePage", "<%=paramRequest.getLocaleString("permanence")%> (<%=cpage.getCounter()%>)", data);

    data = [{"label": "<%=paramRequest.getLocaleString("intern")%>", "value":<%=cpage.getTotalParentCounter()%>},
        {"label": "<%=paramRequest.getLocaleString("extern")%>", "value":<%=(cpage.getCounter() - cpage.getTotalParentCounter())%>}
    ];
    updateChart("#comesPage", "<%=paramRequest.getLocaleString("reference")%> (<%=cpage.getCounter()%>)", data);
                </script>
            </div>
            <!-- Tables for pages -->
            <div class="row">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                    <div class="table-responsive">
                        <table class="table table-hover swbp-table">
                            <thead>
                            <th><%=paramRequest.getLocaleString("continueToChild")%></th><th>Total</th>
                            </thead>
                            <%
                                Iterator<Map.Entry<String, Integer>> it = cpage.getSortedChildSet().descendingIterator();
                                while (it.hasNext()) {
                                    Map.Entry<String, Integer> lc = it.next();
                                    String titleP = lc.getKey().length() > 40 ? SWBUtils.TEXT.cropText(lc.getKey(), 40) : lc.getKey();
                                    out.println("   <tr><td> <a href='?p=" + URLEncoder.encode(lc.getKey()) + "' title='" + lc.getKey() + "'>" + titleP + "</a> </td><td>" + lc.getValue() + "</td></tr>");
                                }
                            %>
                        </table>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                    <div class="table-responsive">
                        <table class="table table-hover swbp-table">
                            <thead>
                            <th><%=paramRequest.getLocaleString("continueToParent")%></th><th>Total</th>
                            </thead>
                            <%
                                it = cpage.getSortedParentSet().descendingIterator();
                                while (it.hasNext()) {
                                    Map.Entry<String, Integer> lc = it.next();
                                    String titleP = lc.getKey().length() > 40 ? SWBUtils.TEXT.cropText(lc.getKey(), 40) : lc.getKey();
                                    out.println("   <tr><td> <a href='?p=" + URLEncoder.encode(lc.getKey()) + "' title='" + lc.getKey() + "'>" + titleP + "</a> </td><td>" + lc.getValue() + "</td></tr>");
                                }
                            %>
                        </table>
                    </div>
                </div>
            </div>           
            <%} else if (totalHits > 0) {%>
            <!-- First row  -->
            <div class="row">
                <!-- Sessiones -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-star"></i> <%=hits%></strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=totalHits%></span>
                                    <%=paramRequest.getLocaleString("hitsTotal")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totalSessions%></span>
                                    <%=paramRequest.getLocaleString("sessionNew")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totalSessionsExist%></span>
                                    <%=paramRequest.getLocaleString("sessionOld")%>
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="sessions"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Permanencia en sitio -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-bookmark"></i> <%=paramRequest.getLocaleString("permanence")%></strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=(totals[0] + totals[1])%></span>
                                    Total
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totals[0]%></span>
                                    <%=paramRequest.getLocaleString("continued")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totals[1]%></span>
                                    <%=paramRequest.getLocaleString("dontContinued")%><br/><br/>
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="continue"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    data = [{"label": "<%=paramRequest.getLocaleString("sessionNew")%>", "value":<%=totalSessions%>},
                        {"label": "<%=paramRequest.getLocaleString("sessionOld")%>", "value":<%=totalSessionsExist%>}
                    ];
                    updateChart("#sessions", "<%=paramRequest.getLocaleString("sessions")%> (<%=totalHits%>)", data);

                    data = [{"label": "<%=paramRequest.getLocaleString("continued")%>", "value":<%=totals[0]%>},
                        {"label": "<%=paramRequest.getLocaleString("dontContinued")%>", "value":<%=totals[1]%>}
                    ];
                    updateChart("#continue", "<%=paramRequest.getLocaleString("permanence")%> (<%=(totals[0] + totals[1])%>)", data);
                </script>
            </div>

            <!-- Second row  -->
            <div class="row">
                <!-- Comes -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-tags"></i> <%=paramRequest.getLocaleString("reference")%> </strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=(totals[2] + totals[3])%></span>
                                    Total
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totals[2]%></span>
                                    <%=paramRequest.getLocaleString("intern")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=totals[3]%></span>
                                    <%=paramRequest.getLocaleString("extern")%>
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="comes"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Páginas y Links -->
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="panel-title">
                                <strong><i class="fa fa-link"></i> <%=paramRequest.getLocaleString("pagesAndLinks")%></strong>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="stats">
                                <div class="stat">
                                    <span class="stat-value"><%=(LinkedPageCounter.size() + LinkedPageCounter.getTotalLinks())%></span>
                                    Total
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=LinkedPageCounter.size()%></span>
                                    <%=paramRequest.getLocaleString("pages")%>
                                </div>
                                <div class="stat">
                                    <span class="stat-value"><%=LinkedPageCounter.getTotalLinks()%></span>
                                    Links
                                </div>
                            </div>
                            <div class="col-lg-8 col-lg-offset-2">
                                <div id="pages"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    data = [{"label": "<%=paramRequest.getLocaleString("intern")%>", "value":<%=totals[2]%>},
                        {"label": "<%=paramRequest.getLocaleString("extern")%>", "value":<%=totals[3]%>}
                    ];
                    updateChart("#comes", "<%=paramRequest.getLocaleString("reference")%> (<%=(totals[2] + totals[3])%>)", data);
                    ;
                    data = [{"label": "Links", "value":<%=LinkedPageCounter.size()%>},
                        {"label": "<%=paramRequest.getLocaleString("pages")%>", "value":<%=LinkedPageCounter.getTotalLinks()%>}
                    ];
                    updateChart("#pages", "<%=paramRequest.getLocaleString("pagesAndLinks")%> (<%=(LinkedPageCounter.size() + LinkedPageCounter.getTotalLinks())%>)", data);
                </script>
            </div>
            <!-- Tables -->
            <div class="table-responsive">
                <table class="table table-hover swbp-table">
                    <thead>
                    <th><%=paramRequest.getLocaleString("page")%></th><th>Hits</th>
                    </thead>
                    <%
                        Iterator<LinkedPageCounter> it = LinkedPageCounter.listPages().descendingIterator();
                        while (it.hasNext()) {
                            LinkedPageCounter lp = it.next();
                            String titleP = lp.getId().length() > 80 ? SWBUtils.TEXT.cropText(lp.getId(), 80) : lp.getId();
                    %> <tr><td> <a href="?p=<%=URLEncoder.encode(lp.getId())%>" title="<%=lp.getId()%>"><%=titleP%></a></td><td> <%=lp.getCounter()%></td></tr>
                            <%
                                }
                            %>
                </table>
            </div>
            <%}%>
        </div>
    </div>
    <%}%>
</div>
<%
    if (rest != null) {
%>
<!meta http-equiv="refresh" content="5; URL=<%//paramRequest.getRenderUrl() + "?log=" + log + "&rest=true"%>"/-->
<script>
    window.setTimeout(function() {
        window.location = '<%=paramRequest.getRenderUrl() + "?log=" + log + "&rest=true"%>'
    }, 5000);
</script>
<%
    }
%>
<script type="text/javascript">
    var winVar;
    function redirect(url) {
//alert("enter redirect");
        //window.location = url;
        window.clearTimeout(winVar);
        winVar = window.setTimeout(function() {
            window.location = url;
        }, 500);
    }
    function submitUrls(url, reference) {
        var log = document.getElementById("log");
        url = url + '?log=' + log.options[log.selectedIndex].value;
        //alert("url: " + url);
        dojo.xhrPost({
            url: url,
            load: function(response, ioArgs)
            {

                return response;
            },
            error: function(response, ioArgs) {
                return response;
            },
            handleAs: "text"
        });
        var logP = "<%=paramRequest.getRenderUrl()%>" + '?log=' + log.options[log.selectedIndex].id + '&rest=true';
        redirect(logP);
        //alert("despues");
    }
</script>
<script type="text/javascript">
    dojo.require("dojo.parser");
</script>
