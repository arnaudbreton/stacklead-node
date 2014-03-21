json2csv = require 'json2csv'
config = require './config.json'

class StackLeadPersonApi
	constructor: (@personProcessedTemplate) ->

	processPerson: (person) ->
		personProcessed = JSON.parse(JSON.stringify(@personProcessedTemplate));

		return if not person?
		personProcessed.fullName = person.person.name

		if person.company?
			personProcessed.currentOrganization = person.company.name 
			if person.person.job_title?
				personProcessed.currentOrganization = personProcessed.currentOrganization + '/' + person.person.job_title

			if person.company.website?
				personProcessed.websites.push person.company.website

		if person.person.twitter?
			personProcessed['twitter/followers'] = person.person.twitter.followers
		if person.person.linkedin?
			personProcessed['linkedin/url'] = person.person.linkedin.url

		personProcessed

config.mode = 'test' if not config.mode

stackLeadPersonApi = new StackLeadPersonApi(config.personTemplate)

if config.mode is 'real'
	express = require 'express'

	rawPersons = []
	personsProcessed = []

	app = express()
	app.use(express.bodyParser())

	app.post '/', (req, res) ->
	  rawPersons.push req.body.data
	  personProcessed = stackLeadPersonApi.processPerson(req.body.data)
	  personsProcessed.push personProcessed

	app.get '/csv', (req, res)->
		json2csv {data: personsProcessed, fields: Object.keys(personProcessedTemplate)}, (err, csv) ->
			if err
				console.error(err)
			else 
				res.send(csv)

	app.get '/raw', (req, res)->
		res.send(rawPersons)

	app.listen(5000)

else if config.mode is 'test'
	fs = require 'fs'
	file = __dirname + '/contact.json';
	fs.readFile file, 'utf8', (err, data) ->
		if (err)
			console.log('Error: ' + err);
			return;

		data = JSON.parse(data)

		personsProcessed = []
		for i in [1..10]
			personsProcessed.push stackLeadPersonApi.processPerson(data)

		json2csv {data: personsProcessed, fields: Object.keys(stackLeadPersonApi.personProcessedTemplate)}, (err, csv) ->
			if err
				console.error(err)
			else 
				console.log(csv)
else
	console.error '#{config.mode} is invalid'


