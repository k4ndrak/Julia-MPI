import MPI

function main()

	MPI.Init()
	comm = MPI.COMM_WORLD
	size = MPI.Comm_size(comm)
	rank = MPI.Comm_rank(comm)

	MPI.Barrier(comm)

	if rank != 0
		send_msg = Array{Float64}(fill(1.0,1))
		MPI.Send(1.0, 0, 0, comm)
	else
		for i in 1:size-1
			# recv_msg = MPI.Status
			teste = MPI.Recv(1, 0, 0, comm)
		end
	end


	# print("rank = $rank, a = $a\n")
	MPI.Finalize()

end

main()