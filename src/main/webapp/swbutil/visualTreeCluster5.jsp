<%-- 
    Document   : visualTreeCluster
    Created on : 03-jul-2013, 15:06:59
    Author     : javier.solis.g
--%><%@page import="org.semanticwb.model.*"%><%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String args="";
    String model=request.getParameter("model");
    String wpage=request.getParameter("wpage");
    String lang=request.getParameter("lang");
    String w=request.getParameter("w");if(w==null)w="1280";
    String h=request.getParameter("h");if(h==null)h="800";
    if(model==null)model="demo";
    args="?model="+model;
    if(wpage!=null)args+="&wpage="+wpage;
    if(lang!=null)args+="&lang="+lang;
    WebSite site=SWBContext.getWebSite(model);    
%> 
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
    <link type="text/css" rel="stylesheet" href="http://mbostock.github.io/d3/talk/20111018/style.css"/>
    <style type="text/css">
body {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  margin: auto;
  position: relative;
  width: 960px;
}

form {
  position: absolute;
  right: 10px;
  top: 10px;
}

.node {
  border: solid 1px white;
  font: 10px sans-serif;
  line-height: 12px;
  overflow: hidden;
  position: absolute;
  text-indent: 2px;
}


    </style>
  </head>
  <body>
    <div id="body">
      <div id="footer">
        Sitio <%=site.getDisplayTitle(lang)%>
        <div class="hint">
          TreeMap, click or option-click to descend or ascend
        </div>
        <div><select>
          <option value="size">Size</option>
          <option value="count">Count</option>
        </select></div>        
      </div>
    </div>
    <script type="text/javascript">
        
var margin = {top: 40, right: 10, bottom: 10, left: 10},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var color = d3.scale.category20c();

var treemap = d3.layout.treemap()
    .size([width, height])
    .sticky(true)
    .value(function(d) { return d.size; });

var div = d3.select("body").append("div")
    .style("position", "relative")
    .style("width", (width + margin.left + margin.right) + "px")
    .style("height", (height + margin.top + margin.bottom) + "px")
    .style("left", margin.left + "px")
    .style("top", margin.top + "px");

d3.json("jsonTree.jsp<%=args%>", function(error, root) {
  var node = div.datum(root).selectAll(".node")
      .data(treemap.nodes)
    .enter().append("div")
      .attr("class", "node")
      .call(position)
      .style("background", function(d) { return d.children ? color(d.name) : null; })
      .text(function(d) { return d.children ? null : d.name; });

  d3.selectAll("input").on("change", function change() {
    var value = this.value === "count"
        ? function() { return 1; }
        : function(d) { return d.size; };

    node
        .data(treemap.value(value).nodes)
      .transition()
        .duration(1500)
        .call(position);
  });
});

function position() {
  this.style("left", function(d) { return d.x + "px"; })
      .style("top", function(d) { return d.y + "px"; })
      .style("width", function(d) { return Math.max(0, d.dx - 1) + "px"; })
      .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
}
    </script>
  </body>
</html>
