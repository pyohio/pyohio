function PyOhioVM (data) {

    var self = this;
    self.type = "PyOhioVM";
    self.syslog = ko.observable();
    self.is_busy = ko.observable();

    self.proposals = ko.observableArray([]);

    self.grab_all_proposals = function () {

        self.syslog("Grabbing all proposals");
        self.is_busy(true);

        return $.ajax({
            url: "/all_proposals.json",
            type: "GET",
            dataType: "json",

            complete: function () {
                self.syslog("Grabbed all proposals");
                self.is_busy(false);
            },

            success: function (data) {
                self.proposals(
                    ko.utils.arrayMap(
                        data,
                        function (x) {
                            x.rootvm = self;
                            return new Proposal(x);
                        }));
            }
        });
    };

    self.grab_top_proposals = function () {

        self.syslog("Grabbing top proposals");
        self.is_busy(true);

        return $.ajax({
            url: "/pretty_schedule.json",
            type: "GET",
            dataType: "json",

            complete: function () {
                self.syslog("Grabbed top proposals");
                self.is_busy(false);
            },

            success: function (data) {
                self.proposals(
                    ko.utils.arrayMap(
                        data,
                        function (x) {
                            x.rootvm = self;
                            return new Proposal(x);
                        }));
            }
        });

    };

};

function Proposal (data) {

    var self = this;
    self.type = "Proposal";
    self.rootvm = data.rootvm;
    self.id = data.id;
    self.title = data.title;
    self.audience_level = data.audience_level;
    self.speaker = data.speaker;
    self.proposal_length = data.proposal_length;
    self.plus_1_votes = data.plus_1_votes;
    self.plus_0_votes = data.plus_0_votes;
    self.minus_0_votes = data.minus_0_votes;
    self.minus_1_votes = data.minus_1_votes;
    self.status = data.status;
    self.total_votes = data.total_votes;
    self.approval_rating = data.approval_rating;
    self.rank = data.rank;
    self.room = data.room;
    self.start_time = data.start_time;
    self.end_time = data.end_time;
};

