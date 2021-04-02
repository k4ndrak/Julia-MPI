import MPI

MPI.Init()
comm = MPI.COMM_WORLD
size = MPI.Comm_size(comm)
rank = MPI.Comm_rank(comm)
# send_mesg = Vector{Char}(undef, 40)
if rank != 0
	send_mesg = Vector{Char}("Greetings from the process $rank of $size")
	MPI.Send(send_mesg, 0, 0, comm)
	# recv_mesg = Vector{Char}(undef, 40)
	# MPI.Recv!(recv_mesg, 0, 0, comm)
else
	println("Greetings from the process $rank of $size ")
	for i in 1:size-1
		recv_mesg = Vector{Char}(undef, 40)
		MPI.Recv!(recv_mesg, i, 0, comm)
		println(String(recv_mesg))
	end
end

sleep(rank*2)
MPI.Barrier(comm)
MPI.Finalize()

