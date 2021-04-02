import MPI

function fat(fatorial, piso)
	if fatorial == 0 return 1 elseif fatorial == piso return fatorial end
	return fatorial*fat(fatorial-1, piso)
end

function multcore(rank, size, comm)

	n = parse(UInt128, ARGS[1])
	control = ceil(n / (size - 1))
	fatorial = n - (rank - 1) * control
	piso = n - rank * control + 1

	if rank != 0
		if fatorial >= 0
			result = fat(fatorial, piso)
			send_msg = Array{UInt128}(undef,1)
			send_msg[1] = result
			MPI.Send(send_msg, 0, 0, comm)
		else
			send_msg = Array{UInt128}(undef,1)
			send_msg[1] = 1
			MPI.Send(send_msg, 0, 0, comm)
		end
	else
		result_fat = 1
		for i in 1:size-1
			recv_msg = Array{UInt128}(undef,1)
			MPI.Recv!(recv_msg, i, 0, comm)
			result_fat *= recv_msg[1]
		end
		print(string(n, "! = $result_fat"))
	end

end

function main()
	MPI.Init()

	comm = MPI.COMM_WORLD
	rank = MPI.Comm_rank(comm)
	size = MPI.Comm_size(comm)

	if size != 1
		multcore(rank, size, comm)
	else
		result_fat = fat(parse(Int32, ARGS[1]), 0)
		print(string(ARGS[1], "! = $result_fat"))
	end

	MPI.Barrier(comm)
	MPI.Finalize()
end

main()