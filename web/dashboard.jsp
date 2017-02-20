<%@page import="java.util.stream.Collectors"%>
<%@page import="java.time.Period"%>
<%@page import="java.time.Instant"%>
<%@page import="async.DataReceiver"%>
<%@page import="java.util.List"%>
<%@page import="org.javatuples.Pair"%>
<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
    <head>
         <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="styles/dashboard.css" type="text/css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <noscript>
            <meta http-equiv="refresh" content="0; URL=/html/javascriptDisabled.html">
        </noscript>
        <title>Dashboard</title>
    </head>
    <body onload="onLoad();">
        <img id="backPhoto" src="images/Creek3.jpeg">
        <header class="title_bar_container"> 
            <div id="HeaderText">Water Quality</div>
        </header>
        <section class = "content_container1" id = "dashboard_container">
            <header class = "content_title_bar" id="login_header"> 
                <div class = "title" >
                    Dashboard
                </div> 
            </header>
            
            <section class = "content_container2" id = "graph_container">    
                <ul class="tab">
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Graph'); hide();"
                           id="GraphTab">Graph</a></li>
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Table'); hide();"
                           id="TableTab">Table</a></li>
                    <li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Export'); hide();"
                       id="ExportTab">Export</a></li>
                </ul>
                    <div id="Graph" class="tabcontent">
                        <canvas id="myChart" width=25% height=20%></canvas>
                    </div>
                    <div id="Table" class="tabcontent" style="height:400px;overflow:auto;">
                    ${Table}
                    </div>
                    <div id="Export" class="tabcontent">
                        <img id="Excel" src="images/excel.png" onclick="exportData('Excel')">
                    </div>
            </section>
            
            <aside class = "content_container2" id = "dashboard_data_container">
            <header class = "content_title_bar" id="login_header"> 
                <div class = "title" >
                    Data Type
                </div>
            </header> 
                <%--The <code>data_type_form</code> allows the user to select
                    the desired data to be outputed into either a table or
                    a graph
                --%>
                <form id="data_type_form" action="ControlServlet" method = "POST">
                    <!--<div id="dateInstructDiv">Start Date to End Date</div>
                    <div id="dateselectordiv"><input class="dateselector" type="date" name="startdate"> to
                    <input class="dateselector" type="date" name="enddate"></div>-->
                    <div class="" id="select_all_toggle"><input type="checkbox" onclick="toggle(this);" 
                           id="select_all_data" value="select_all_data">Select all</div><br>
                    ${Parameters}
                    <input type="submit" name="Get Data" value="Get Data" />
                    <input type="hidden" name="control" value ="getData">
                    <br>
                    
                    <div class="data_type_submit" id="Graph_submit"><input type="submit" value="Graph" onclick="graphSubmit()"></div>
                    <div class="data_type_submit" id="Table_submit"><input type="submit" value="Table"></div>
                    
                </form>
                    
                    <form id="submit_query" action="ControlServlet" value="Submit Query">
                        <input type="hidden" name="control" value="submitQuery">
                         <div class="data_type_submit" id="Graph_submit" onclick="graphSubmit()"><input type="submit" ></div>
                        <div class="data_type_submit" id="Table_submit" ><input type="submit" ></div>
                    </form>
            </aside><br>
            
            <!--The data description box is defined here. Sample text is shown-->
            <!--to provide an indication of the text-wrapping.-->
            <!--This will need to pull text from a file which Brandon already-->
            <!--typed and had Dr. Rier edit.-->
            <section class = "content_container2" id = "dashboard_data_description">
                <header class = "content_title_bar" id = "login_header">
                    <div class = "title">
                        Description
                    </div>
                </header>
                
                <p id="tmp"> </p>
                <!--datadesc is supposed to act the same as DummyData, it's the placeholder for the information from ControlServlet-->
                <p>${Descriptions}</p>
            </section>
                   
                   
            
        </section> 
    
                   
        <script>
            function post(path, params, method) {
                method = method || "post"; // Set method to post by default if not specified.

                // The rest of this code assumes you are not using a library.
                // It can be made less wordy if you use one.
                var form = document.createElement("form");
                form.setAttribute("method", method);
                form.setAttribute("action", path);

                for(var key in params) {
                    if(params.hasOwnProperty(key)) {
                        var hiddenField = document.createElement("input");
                        hiddenField.setAttribute("type", "hidden");
                        hiddenField.setAttribute("name", key);
                        hiddenField.setAttribute("value", params[key]);

                        form.appendChild(hiddenField);
                     }
                }

                document.body.appendChild(form);
                form.submit();
            }
            
            function handleClick(cb)
            {
                if(current=='Graph') {
                    fullCheck(cb.id);
                }
//                post("ControlServlet", {key: 'control', control: 'getDesc'});
            }
 
            function graphSubmit(){
                var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                var data = "{ data: [";
                for (var i = 0; i < checkboxes.length; i++) {
                    if(checkboxes[i].checked==true) {
                        data += checkbox[i].id.toString();
                    }
                }
                data += "] }";
                
                post("ControlServlet", {key: 'control', control: 'getData ' + data});
            }
            
            function exportData(id){
                document.write(id);
            }
        </script>
            ${ChartJS}
        <script type="text/javascript">
            document.getElementById("GraphTab").click();
            var current;
            /**
             * The <code>openTab</code> function activates a certain event
             * based on the provided <code>tabName</code> parameter
             * @param {type} evt
             * @param {type} tabName the tab that the user is switching to
             */
            function openTab(evt, tabName) {
                var i, tabcontent, tablinks,submitbutton;
                tabcontent = document.getElementsByClassName("tabcontent");
                
                
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].style.display = "none";
                }
                
                tablinks = document.getElementsByClassName("tablinks");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].className = tablinks[i].className.replace(" active", "");
                }
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";
                
                //unchecks all of the checkboxes
                toggle(this);
                checkedBoxes=0;
                //<code>current</code>holds the current <code>tabName</code>
                //This is done because we need to limit the number of boxes checked
                //for the Graph tab and not the Table tab
                current=tabName;
                submitbutton=document.getElementsByClassName("data_type_submit");
                for(i=0; i<submitbutton.length; i++){
                    submitbutton[i].style.display="none";
                }
                document.getElementById(current+"_submit").style.display = "block";
            }
            
            /**
             * The <code>toggle</code> function checks or unchecks
             * all of the checkboxes in the given <code>source</code> 
             * @param {type} source
             */
            function toggle(source) {
                var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                for (var i = 0; i < checkboxes.length; i++) {
                    if (checkboxes[i] != source)
                        checkboxes[i].checked = source.checked;
                }
            }
            
            /**
             * The <code>hide</code> function hides the
             * <code>select_all_toggle</code> checkbox when the Graph tab
             * is selected and reveals the checkbox when the table
             * tab is selected
             */
            function hide(){
                var item=document.getElementById("select_all_toggle");
                if(current=='Table')
                    item.className='unhide';
                else
                    item.className='hide';
            }
            
            var checkedBoxes=0;
            /**
             * The <code>fullCheck</code> function limits the number of data
             * checkboxes checked at a time to 3 by unchecking <coe>id</code>
             * if <code>checkedBoxes</code> equals 3
             * @param {type} id the current data type the user is trying to check
             */
            function fullCheck(id){
                var item=document.getElementById(id);
                if(item.checked==true){
                    if(checkedBoxes<2)
                        checkedBoxes++;
                    else{
                        item.checked=false;
                    }
                }
                else
                    checkedBoxes--;
            }
            
            
        </script>
    </body>
</html>