<%@page contentType="text/html"%>
<%@page import="org.semanticwb.opensocial.resources.*,org.semanticwb.opensocial.model.*,org.semanticwb.opensocial.resources.*,java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%><%
    String context=SWBPortal.getContextPath();
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");

    SWBResourceURL proxy = paramRequest.getRenderUrl();
    proxy.setCallMethod(SWBResourceURL.Call_DIRECT);
    proxy.setMode(SocialContainer.Mode_PROXY);


    SWBResourceURL javascript = paramRequest.getRenderUrl();
    javascript.setMode(SocialContainer.Mode_JAVASCRIPT);
    javascript.setCallMethod(SWBResourceURL.Call_DIRECT);
    javascript.setParameter("script", "core_rpc.js");
    javascript.setParameter("debug","0");

    

    SWBResourceURL rpc = paramRequest.getRenderUrl();
    rpc.setCallMethod(SWBResourceURL.Call_DIRECT);
    rpc.setMode(SocialContainer.Mode_RPC);

    String html=request.getAttribute("html").toString();

    String msg=request.getAttribute("msg").toString();
    String default_values=request.getAttribute("default_values").toString();

    SWBResourceURL makerequest = paramRequest.getRenderUrl();
    makerequest.setCallMethod(SWBResourceURL.Call_DIRECT);
    makerequest.setMode(SocialContainer.Mode_MAKE_REQUEST);

    
%>
<html><head>
        <link rel="stylesheet" href="<%=context%>/swbadmin/dojo1_5/dijit/themes/claro/claro.css">
        <link rel="stylesheet" href="<%=context%>/swbadmin/dojo1_5/dijit/themes/claro/layout/ContentPane.css">
        <link rel="stylesheet" href="<%=context%>/swbadmin/dojo1_5/dijit/themes/tundra/tundra.css">
        <link rel="stylesheet" href="<%=context%>/swbadmin/dojo1_5/dijit/themes/soria/soria.css">

        <script type="text/javascript" src="<%=context%>/swbadmin/dojo1_5/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
        <link rel="stylesheet" href="<%=context%>/swbadmin/dojo1_5/dojo/resources/dojo.css">
        <style type="text/css">body,td,div,span,p{font-family:arial,sans-serif;}a {color:#0000cc;}a:visited {color:#551a8b;}a:active {color:#ff0000;}body{margin: 0px;padding: 0px;background-color:white;}</style>
        <script>window['__isgadget']=true;</script>
        <script src="<%=javascript%>"></script>
        <script>gadgets.rpc.register("update_security_token",function(A){shindig.auth.updateSecurityToken(A)
        });;
        (function(){osapi._registerMethod=function(G,F){

                var A=typeof ___!=="undefined";
                if(G=="newBatch"){
                    return
                }var D=G.split(".");
                var C=osapi;
                for(var B=0;
                B<D.length-1;
                B++){C[D[B]]=C[D[B]]||{};
                    C=C[D[B]]
                }var E=function(J){var I=osapi.newBatch();
                    var H={};
                    H.execute=function(M){var K=A?___.untame(M):M;
                        var L=A?___.USELESS:this;
                        I.add(G,this);
                        I.execute(function(N){if(N.error){K.call(L,N.error)
                            }else{K.call(L,N[G])
                            }})
                    };
                    if(A){___.markInnocent(H.execute,"execute")
                    }J=J||{};
                    J.userId=J.userId||"@viewer";
                    J.groupId=J.groupId||"@self";
                    H.method=G;
                    H.transport=F;
                    H.rpc=J;
                    return H
                };
                if(A&&typeof ___.markInnocent!=="undefined"){___.markInnocent(E,G)
                }if(C[D[D.length-1]]){gadgets.warn("Skipping duplicate osapi method definition "+G+" on transport "+F.name)
                }else{C[D[D.length-1]]=E
                }}
        })();;
        (function(){var A=function(){var C={};
                var B=[];
                var F=function(G,H){if(H&&G){B.push({key:G,request:H})
                    }return C
                };
                var E=function(H){var G={method:H.request.method,id:H.key};
                    if(H.request.rpc){G.params=H.request.rpc
                    }return G
                };
                var D=function(G){var H={};
                    var O={};
                    var J=0;
                    var K=[];
                    for(var M=0;
                    M<B.length;
                    M++){var I=B[M].request.transport;
                        if(!O[I.name]){K.push(I);
                            J++
                        }O[I.name]=O[I.name]||[];
                        O[I.name].push(E(B[M]))
                    }var N=function(S){if(S.error){H.error=S.error
                        }for(var R=0;
                        R<B.length;
                        R++){var Q=B[R].key;
                            var P=S[Q];
                            if(P){if(P.error){H[Q]=P
                                }else{H[Q]=P.data||P.result
                                }}}J--;
                        if(J===0){G(H)
                        }};
                    for(var L=0;
                    L<K.length;
                    L++){K[L].execute(O[K[L].name],N)
                    }if(J==0){window.setTimeout(function(){G(H)
                        },0)
                    }};
                C.execute=D;
                C.add=F;
                return C
            };
            osapi.newBatch=A
        })();;
        (function(){function A(H,G){
                function F(J){
                    if(J.errors[0])
                    {
                        G({error:{code:J.rc,message:J.text}})
                    }else
                    {
                        var K=J.result||J.data;
                        if(K.error){G(K)
                        }else{var I={};
                            for(var L=0;
                            L<K.length;
                            L++){I[K[L].id]=K[L]
                            }G(I)
                        }}}var E={POST_DATA:gadgets.json.stringify(H),CONTENT_TYPE:"JSON",METHOD:"POST",AUTHORIZATION:"SIGNED"};
                var C=this.name;
                var D=shindig.auth.getSecurityToken();
                if(D){C+="?st=";
                    C+=encodeURIComponent(D)
                }gadgets.io.makeNonProxiedRequest(C,F,E,"application/json")
            }function B(F){var H=F["osapi.services"];
                if(H){for(var E in H){if(H.hasOwnProperty(E)){if(E.indexOf("http")==0||E.indexOf("//")==0){var C=E.replace("%host%",document.location.host);
                                var I={name:C,execute:A};
                                var D=H[E];
                                for(var G=0;
                                G<D.length;
                                G++){osapi._registerMethod(D[G],I)
                                }}}}}}if(gadgets.config){gadgets.config.register("osapi.services",null,B)
            }})();;
        if(gadgets&&gadgets.rpc){(function(){function A(E,D){var C=function(G){if(!G){D({code:500,message:"Container refused the request"})
                        }else{if(G.error){D(G)
                            }else{var F={};
                                for(var H=0;
                                H<G.length;
                                H++){F[G[H].id]=G[H]
                                }D(F)
                            }}};
                    gadgets.rpc.call("..","osapi._handleGadgetRpcMethod",C,E)
                }function B(C){var F={name:"gadgets.rpc",execute:A};
                    var K=C["osapi.services"];
                    if(K){for(var D in K){if(K.hasOwnProperty(D)){if(D==="gadgets.rpc"){var E=K[D];
                                    for(var H=0;
                                    H<E.length;
                                    H++){osapi._registerMethod(E[H],F)
                                    }}}}}if(osapi.container&&osapi.container.listMethods){var G=gadgets.util.runOnLoadHandlers;
                        var I=2;
                        var J=function(){I--;
                            if(I==0){G()
                            }};
                        gadgets.util.runOnLoadHandlers=J;
                        osapi.container.listMethods({}).execute(function(L){if(!L.error){for(var M=0;
                                M<L.length;
                                M++){if(L[M]!="container.listMethods"){osapi._registerMethod(L[M],F)
                                    }}}J()
                        });
                        window.setTimeout(J,500)
                    }}if(gadgets.config&&gadgets.config.isGadget){gadgets.config.register("osapi.services",null,B)
                }})()
        };;
        gadgets.util.registerOnLoadHandler(function(){if(osapi&&osapi.people&&osapi.people.get){osapi.people.getViewer=function(A){A=A||{};
                    A.userId="@viewer";
                    A.groupId="@self";
                    return osapi.people.get(A)
                };
                osapi.people.getViewerFriends=function(A){A=A||{};
                    A.userId="@viewer";
                    A.groupId="@friends";
                    return osapi.people.get(A)
                };
                osapi.people.getOwner=function(A){A=A||{};
                    A.userId="@owner";
                    A.groupId="@self";
                    return osapi.people.get(A)
                };
                osapi.people.getOwnerFriends=function(A){A=A||{};
                    A.userId="@owner";
                    A.groupId="@friends";
                    return osapi.people.get(A)
                }
            }});;
        var tamings___=tamings___||[];
        tamings___.push(function(A){___.tamesTo(osapi.newBatch,___.markFuncFreeze(function(){var C=osapi.newBatch();
                ___.markInnocent(C.add,"add");
                ___.markInnocent(C.execute,"execute");
                return ___.tame(C)
            }));
            A.outers.osapi=___.tame(osapi);
            ___.grantRead(A.outers,"osapi");
            var B=A;
            gadgets.util.registerOnLoadHandler(function(){if(osapi&&osapi.people&&osapi.people.get){caja___.whitelistFuncs([[osapi.people,"getViewer"],[osapi.people,"getViewerFriends"],[osapi.people,"getOwner"],[osapi.people,"getOwnerFriends"]]);
                    B.outers.osapi.people.getViewer=___.tame(osapi.people.getViewer);
                    B.outers.osapi.people.getViewerFriends=___.tame(osapi.people.getViewerFriends);
                    B.outers.osapi.people.getOwner=___.tame(osapi.people.getOwner);
                    B.outers.osapi.people.getOwnerFriends=___.tame(osapi.people.getOwnerFriends)
                }})
        });;
        gadgets.window=gadgets.window||{};
        (function(){gadgets.window.getViewportDimensions=function(){var A=0;
                var B=0;
                if(self.innerHeight){A=self.innerWidth;
                    B=self.innerHeight
                }else{if(document.documentElement&&document.documentElement.clientHeight){A=document.documentElement.clientWidth;
                        B=document.documentElement.clientHeight
                    }else{if(document.body){A=document.body.clientWidth;
                            B=document.body.clientHeight
                        }}}return{width:A,height:B}
            }
        })();;
        gadgets.window=gadgets.window||{};
        (function(){var C;
            function A(F,D){var E=window.getComputedStyle(F,"");
                var G=E.getPropertyValue(D);
                G.match(/^([0-9]+)/);
                return parseInt(RegExp.$1,10)
            }function B(){var E=0;
                var D=[document.body];
                while(D.length>0){var I=D.shift();
                    var H=I.childNodes;
                    for(var G=0;
                    G<H.length;
                    G++){var J=H[G];
                        if(typeof J.offsetTop!=="undefined"&&typeof J.scrollHeight!=="undefined"){var F=J.offsetTop+J.scrollHeight+A(J,"margin-bottom");
                            E=Math.max(E,F)
                        }D.push(J)
                    }}return E+A(document.body,"border-bottom")+A(document.body,"margin-bottom")+A(document.body,"padding-bottom")
            }gadgets.window.adjustHeight=function(I){var F=parseInt(I,10);
                var E=false;
                if(isNaN(F)){E=true;
                    var K=gadgets.window.getViewportDimensions().height;
                    var D=document.body;
                    var J=document.documentElement;
                    if(document.compatMode==="CSS1Compat"&&J.scrollHeight){F=J.scrollHeight!==K?J.scrollHeight:J.offsetHeight
                    }else{if(navigator.userAgent.indexOf("AppleWebKit")>=0){F=B()
                        }else{if(D&&J){var G=J.scrollHeight;
                                var H=J.offsetHeight;
                                if(J.clientHeight!==H){G=D.scrollHeight;
                                    H=D.offsetHeight
                                }if(G>K){F=G>H?G:H
                                }else{F=G<H?G:H
                                }}}}}if(F!==C&&!isNaN(F)&&!(E&&F===0)){C=F;
                    gadgets.rpc.call(null,"resize_iframe",null,F)
                }}
        }());
        var _IG_AdjustIFrameHeight=gadgets.window.adjustHeight;;
        var tamings___=tamings___||[];
        tamings___.push(function(A){caja___.whitelistFuncs([[gadgets.window,"adjustHeight"],[gadgets.window,"getViewportDimensions"]])
        });;
        gadgets.window=gadgets.window||{};
        gadgets.window.setTitle=function(A){gadgets.rpc.call(null,"set_title",null,A)
        };
        var _IG_SetTitle=gadgets.window.setTitle;;
        gadgets.config.init({"shindig.auth":{},"osapi":{"endPoints":["http://%host%<%=rpc%>"]},"osapi.services":{"gadgets.rpc":["container.listMethods"],"http://%host%<%=rpc%>":["samplecontainer.update","albums.update","albums.supportedFields","activities.delete","activities.supportedFields","gadgets.metadata","activities.update","mediaItems.create","albums.get","activities.get","http.put","activitystreams.create","messages.modify","appdata.get","messages.get","system.listMethods","samplecontainer.get","cache.invalidate","people.supportedFields","http.head","http.delete","messages.create","people.get","activitystreams.get","mediaItems.supportedFields","mediaItems.delete","albums.delete","activitystreams.update","mediaItems.update","messages.delete","appdata.update","gadgets.tokenSupportedFields","http.post","activities.create","samplecontainer.create","http.get","albums.create","appdata.delete","gadgets.token","appdata.create","activitystreams.delete","gadgets.supportedFields","mediaItems.get","activitystreams.supportedFields"]},"rpc":{"parentRelayUrl":"/container/rpc_relay.html","useLegacyProtocol":false},"core.util":{"dynamic-height":{},"osapi":{},"core":{},"settitle":{}},"core.io":{"proxyUrl":"//%host%<%=proxy%>?container=default&refresh=%refresh%&url=%url%%rewriteMime%","jsonProxyUrl":"//%host%<%=makerequest%>"}});
        </script><script type="text/javascript">gadgets.Prefs.setMessages_(<%=msg%>);gadgets.Prefs.setDefaultPrefs_(<%=default_values%>);gadgets.io.preloaded_=[];</script>
        <script type="text/javascript">
                dojo.require("dijit.layout.ContentPane");
                dojo.require("dijit.layout.TabContainer");
        </script>
    </head>
    <body class="soria">

        <%=html%>
    </body></html>