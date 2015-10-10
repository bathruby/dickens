# Description:
#   Retrieves the latest meetup from Meetup.com
#
# Dependencies:
#   "moment": "^2.10.6"
#
# Configuration:
#   MEETUP_URL
#
# Commands:
#   next meetup - Displays information about the next meetup
#
# Author:
#   jordelver
#
moment = require('moment')

module.exports = (robot) ->

  robot.hear /next meetup/i, (msg) ->
    msg.http(process.env.MEETUP_URL)
      .get() (err, res, body) ->
        responses = JSON.parse(body)
        meetup    = nextMeetup(responses)
        msg.send formatMessage(meetup)

nextMeetup = (responses) ->
  meetup(responses[0])

meetup = (response) ->
  {
    date:      parseDate(response.local_time).format('dddd Do MMMM [at] h:mmA')
    venue:     response.venue_name,
    event_url: response.event_url
  }

formatMessage = (meetup) ->
  message  = "The next meetup is on #{meetup.date}\n"
  message += "It's being held at #{meetup.venue}\n"
  message += "Why not come along? To RSVP visit #{meetup.event_url}\n"
  message

parseDate = (dateString) ->
  moment(dateString, 'YYYY-MM-DD HH:mm:ss Z')

