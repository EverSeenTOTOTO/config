local present, db = pcall(require, "nvim-tree")

if not present then
	return
end

db.setup()
