<%@ Control Language="c#" AutoEventWireup="true" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<div id="InnerCenter">
    <div id="Header">
        <img src="-/media/Default Website/sc_logo.ashx" alt="Sitecore" id="scLogo" />
        <p style="margin: 0 16px; font-size: 30px;">&#43;</p>
        <img src="/images/docker-logo.png" alt="Docker" />
    </div>
    <div id="Content">
        <div id="LeftContent">
            <sc:placeholder runat="server" key="content" />
        </div>				
    </div>
    <div id="Footer"><hr class="divider"/>&#169; <%= Sitecore.DateUtil.ToServerTime(DateTime.UtcNow).Year.ToString()%> Sitecore</div>
</div>