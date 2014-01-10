_ = require 'underscore'
Instagram = require 'instagram-node-lib'
express = require 'express'
app = express()

Instagram.set 'client_id', 'b8b6e83a5194471d936670c484375a5d'
Instagram.set 'client_secret', '7a56b096833d41ff98f55369c837ef0d'

app.get '/public', (req, res) ->
    Instagram.media.popular {
        complete: (data, pagination) ->
            res.send data
    }

#searchUser = (user) ->
    #Instagram.users.search {
        #q: user,
        #complete: (data, pagination) ->
            #Instagram.users.recent {
                #user_id: data[0].id,
                #complete: parseImages
            #}
    #}
    #
app.listen 3131
