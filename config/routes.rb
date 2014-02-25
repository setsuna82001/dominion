Dominion::Application.routes.draw do
	root	"display#index"
	get		"display/index"
	post	"display/index"

	post	"history/drop"
	post	"history/save"
	post	"history/list"

	post	"notice/send"
	get 	"popup/display"
end
