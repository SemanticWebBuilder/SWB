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
    String w=request.getParameter("w");if(w==null)w="960";
    String h=request.getParameter("h");if(h==null)h="2200";    
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
    <link type="text/css" rel="stylesheet" href="http://mbostock.github.io/d3/talk/20111018/style.css"/>    
    <style type="text/css">
        
.node circle {
  fill: #fff;
  stroke: steelblue;
  stroke-width: 1.5px;
}

.node {
  font: 10px sans-serif;
}

.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}

    </style>
  </head>
  <body>
    <script src="http://d3js.org/d3.v3.min.js"></script>
    <div id="body">
      <div id="footer">
        Sitio <%=site.getDisplayTitle(lang)%>
        <div class="hint">
          Reingold–Tilford Tree
        </div>
      </div>
    </div>
<script>

var diameter = <%=w%>;

var tree = d3.layout.tree()
    .size([360, diameter / 2 - 120])
    .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });

var diagonal = d3.svg.diagonal.radial()
    .projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });

var svg = d3.select("body").append("svg")
    .attr("width", diameter)
    .attr("height", diameter - 150)
  .append("g")
    .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");

d3.json("jsonTree.jsp<%=args%>", function(error, root) {
  var nodes = tree.nodes(root),
      links = tree.links(nodes);

  var link = svg.selectAll(".link")
      .data(links)
    .enter().append("path")
      .attr("class", "link")
      .attr("d", diagonal);

  var node = svg.selectAll(".node")
      .data(nodes)
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })

  node.append("circle")
      .attr("r", 4.5);

  node.append("text")
      .attr("dy", ".31em")
      .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
      .attr("transform", function(d) { return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)"; })
      .text(function(d) { return d.name; });
});

d3.select(self.frameElement).style("height", diameter - 150 + "px");

</script>
  </body>
</html>
