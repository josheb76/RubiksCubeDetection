function sol = Solve45(R)
%
% Solve the cube using T45
%

P = load('Prunes');
P1 = P.P1;
P2 = P.P2;
P3 = P.P3;
P4 = P.P4;

sol = [];

E = GetEdges(R);
C = GetCorners(R);

%PHASE 1: CURE EDGES
moves = {'L'  ,'R'  ,'F'  ,'B'  ,'U'  ,'D';...
         'L2' ,'R2' ,'F2' ,'B2' ,'U2' ,'D2';...
         'L''','R''','F''','B''','U''','D'''};

n = State2Ind(E(2,:))+1;
N = P1(n);

while N>0
    for i=1:18
        E2 = TwistEdges(E,moves{i});
        n = State2Ind(E2(2,:))+1;
        M = P1(n);
        if M<N
            N = M;
            E = E2;
            C = TwistCorners(C,moves{i});
            sol = [sol moves(i)];
            break
        end
    end
end

%PHASE 2: MOVE LR-SLICE EDGES TO UD-SLICE + ORIENT CORNERS
moves = {'L'  ,'R'  ,'F'  ,'B'  ,'U2';...
         'L2' ,'R2' ,'F2' ,'B2' ,'D2';...
         'L''','R''','F''','B''','00'};

Clist = P.ClistP2;
Elist = P.ElistP2;

F = E(1,:);
F = double(F>=9);
Cind = State2Ind(C(2,:));
Eind = State2Ind(F);

n = Clist==Cind;
m = Elist==Eind;

N = P2(n,m);

while N>0
    for i=1:14
        C2 = TwistCorners(C,moves{i});
        E2 = TwistEdges(E,moves{i});
        F2 = E2(1,:);
        F2 = double(F2>=9);
        Cind = State2Ind(C2(2,:));
        Eind = State2Ind(F2(1,:));
		n = Clist==Cind;
		m = Elist==Eind;
        M = P2(n,m);
        if M<N
            N = M;
            C = C2;
            E = E2;
            sol = [sol moves(i)];
            break
        end
    end
end

%PHASE 3: FIX EDGES IN THEIR SLICE W/ EVEN PERMUTATION + FIX CORNERS IN
%         ORBIT W/ EVEN PERMUTATION
moves = {'L' ,'L''','L2',...
         'R' ,'R''','R2',...
         'F2','B2','U2','D2'};

Clist = P.ClistP3;
Elist = P.ElistP3;

F = ceil(E(1,1:8)/4)-1;

Cind = State2Ind(C(1,:));
Eind = State2Ind(F,2);

n = find(Clist==Cind);
m = find(Elist==Eind);
N = P3(n,m);

while N>0
    for i=1:10
        C2 = TwistCorners(C,moves{i});
        E2 = TwistEdges(E,moves{i});
        F = ceil(E2(1,1:8)/4)-1;
        Cind = State2Ind(C2(1,:));
        Eind = State2Ind(F,2);
        n = Clist==Cind;
        m = Elist==Eind;
        M = P3(n,m);
        if M<N
            N = M;
            C = C2;
            E = E2;
            sol = [sol moves(i)];
            break
        end
    end
end

%PHASE 4: SOLVE THE CUBE
moves = {'L2','R2','F2','B2','U2','D2'};

Clist = P.ClistP4;
Elist = P.ElistP4;

Cind = State2Ind(C(1,:));
Eind = State2Ind(E(1,:));

n = Clist==Cind;
m = Elist==Eind;
N = P4(n,m);

while N>0
    for i=1:6
        C2 = TwistCorners(C,moves{i});
        E2 = TwistEdges(E,moves{i});
        Cind = State2Ind(C2(1,:));
        Eind = State2Ind(E2(1,:));
        n = Clist==Cind;
        m = Elist==Eind;
        M = P4(n,m);
        if M<N
            N = M;
            C = C2;
            E = E2;
            sol = [sol moves(i)];
            break
        end
    end
end

sol = rubopt(sol);

