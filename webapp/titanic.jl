using JLD2, DecisionTree

# Returns 1 if a passenger with
# specified 'data' survived or 0 if not
function isSurvived(data)
	model = load_object("titanic.jld2")
	survived = predict(model,data)
	return survived[1]
end

using HTTP,JSON3

function handle(req)
    if req.method == "POST"
        form = JSON3.read(String(req.body))
        println(form)
        survived = isSurvived([
            form.pclass
            form.sex
            form.age
            form.sibsp
            form.parch
            form.fare
            form.embarked
        ])
        return HTTP.Response(200,"$survived")
    end
    return HTTP.Response(200,read("./index.html"))
end

HTTP.serve(handle, 8080)

