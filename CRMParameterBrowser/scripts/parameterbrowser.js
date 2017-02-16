var messageNames = new Array();
var data = null;

function onLoad() {
    $("#optCRM16").prop("checked", true);
    loadData("2016");
}

function loadData(urlKey) {
    $('#spinner').show();

    Tabletop.init({
        key: getUrl(urlKey),
        callback: showMessages,
        simpleSheet: true
    });
}

function getUrl(urlKey) {
    switch (urlKey) {
        case "2011":
            return "https://docs.google.com/spreadsheets/d/1zVG6ZUUxlXI3eHi24IlVakFuKmquEZAFrWW2ZXX9h_8/pubhtml?gid=529045558&single=true";
        case "2013":
            return "https://docs.google.com/spreadsheets/d/1zVG6ZUUxlXI3eHi24IlVakFuKmquEZAFrWW2ZXX9h_8/pubhtml?gid=870246102&single=true";
        case "2015":
            return "https://docs.google.com/spreadsheets/d/1zVG6ZUUxlXI3eHi24IlVakFuKmquEZAFrWW2ZXX9h_8/pubhtml?gid=0&single=true";
        case "2016":
            return "https://docs.google.com/spreadsheets/d/1zVG6ZUUxlXI3eHi24IlVakFuKmquEZAFrWW2ZXX9h_8/pubhtml?gid=338613996&single=true";
        default:
            return "";
    }
}

function showMessages(sheet) {
    data = sheet;
    $("#ddlMessage").empty();
    $('#ddlMessage').append($("<option></option>")
                .attr("value", -1)
                .text("Select..."));

    messages = null;
    var messageName = "";
    $.each(data, function (index) {
        if (messageName != data[index].Message) {
            messageName = data[index].Message;
            messageNames.push(data[index].Message);
            $('#ddlMessage').append($("<option></option>")
                .attr("value", index)
                .text(data[index].Message));
        }
    });

    showParameters();
    $('#spinner').hide();
}

function loadParameters() {
    var selectedMessage = $('#ddlMessage :selected').text();
    var parameters = getParameters(selectedMessage);
    showParameters(parameters);
}

function getParameters(messageName) {
    return data.filter(function (el) {
        return el.Message == messageName;
    });
}

function showParameters(parameters) {
    $("#inputParameters ul").empty();
    $("#outputParameters ul").empty();

    $.each(parameters, function (index) {
        if (parameters[index].ParameterType == "InputParameter") {
            insertListItem("#inputParameters", parameters[index].PropertyName, parameters[index].PropertyType, parameters[index].Required);
        }
        else {
            insertListItem("#outputParameters", parameters[index].PropertyName, parameters[index].PropertyType, parameters[index].Required);
        }
    });

    if ($('#outputParameters li').length < 1) {
        insertListItem("#outputParameters");
    }

    if ($('#inputParameters li').length < 1) {
        insertListItem("#inputParameters");
    }
}

function insertListItem(selector, name, type, required) {
    if (name != null) {
        var requiredTag = required == true ? "<span class='tag tag-primary float-xs-right'> Required </span>" : "";
        $(selector + " ul").append("<li class='list-group-item left-margin-li'><span class='tag tag-default float-xs-right'>" + type + "</span>" + requiredTag + name + "</li>");
    }
    else {
        $(selector + " ul").append("<li class='list-group-item left-margin-li'></li>");
    }
}